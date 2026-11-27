defmodule ExBdd.Messages.EmitterUnitTest do
  # async: false: the coordinator is a named singleton, and every test resets it.
  use ExUnit.Case, async: false

  alias ExBdd.Messages.{Emitter, Recorder}
  alias ExBdd.{RunCoordinator, StepRegistry}
  alias ExBdd.TestCase.HookStep

  defmodule ParamTypes do
    use ExBdd.ParameterTypes

    parameter_type(:zebra, regexp: ~r/z+/)
    parameter_type(:apple, regexp: ~r/a+/)
  end

  defmodule Hooks do
    def setup(_context), do: :ok
  end

  setup do
    RunCoordinator.ensure_started()
    on_exit(fn -> RunCoordinator.ensure_started() end)
    :ok
  end

  defp recorded_envelopes do
    %{recorder: recorder} = :sys.get_state(RunCoordinator)
    Recorder.envelopes(recorder)
  end

  describe "configure/6 (deprecated)" do
    # @scenario specs/behaviours/messages_stream.feature: config messages writes the Cucumber Messages stream
    test "still configures the sink, ignoring the parameter types argument" do
      registry = StepRegistry.new([])

      # Called through apply/3 so the deprecation doesn't warn at compile time
      # credo:disable-for-next-line Credo.Check.Refactor.Apply
      assert apply(Emitter, :configure, ["unused.ndjson", [], registry, [], %{}, 5]) == :ok
      assert Enum.any?(recorded_envelopes(), &match?(%{meta: _}, &1))
    end
  end

  describe "configure/5 with hooks and parameter types" do
    test "each hook is announced with its type, tag, name, and defining file" do
      registry = StepRegistry.new([])
      hooks = [{:before_all, "@slow", "warm up", {Hooks, :setup}}]

      assert :ok = Emitter.configure("unused.ndjson", [], registry, hooks, 1)

      assert [%{hook: hook}] = Enum.filter(recorded_envelopes(), &match?(%{hook: _}, &1))
      assert %{id: "1", type: "BEFORE_TEST_RUN", tagExpression: "@slow", name: "warm up"} = hook
      assert hook.sourceReference.uri =~ "emitter_unit_test.exs"
    end

    test "parameter types are announced in name order" do
      registry = StepRegistry.new([], [ParamTypes])

      assert :ok = Emitter.configure("unused.ndjson", [], registry, [], 1)

      names = for %{parameterType: %{name: name}} <- recorded_envelopes(), do: name
      assert names == ["apple", "zebra"]
    end
  end

  describe "hook_around/1" do
    setup do
      session = %{test_case_id: "1", case_started_id: "2", step_ids: %{0 => "3"}}
      hook_step = %HookStep{position: 0, name: "tidy", ref: {Hooks, :setup}}

      {:ok, around: Emitter.hook_around(session), hook_step: hook_step}
    end

    test "the hook runs with its own message reference and its result is returned", ctx do
      result =
        ctx.around.(ctx.hook_step, fn overrides ->
          send(self(), {:overrides, overrides})
          :ok
        end)

      assert result == :ok

      assert_received {:overrides,
                       %{ex_bdd_message_ref: %{test_case_started_id: "2", test_step_id: "3"}}}
    end

    test "an exception from the hook is re-raised", ctx do
      assert_raise RuntimeError, "boom", fn ->
        ctx.around.(ctx.hook_step, fn _overrides -> raise "boom" end)
      end
    end

    test "every kind of hook result is handed back unchanged", ctx do
      results = [
        {:halted, :failed, "bad"},
        {:error, :reason},
        :pending,
        :skipped,
        {:pending, "later"},
        {:skipped, "why"},
        {:ok, %{}}
      ]

      for result <- results do
        assert ctx.around.(ctx.hook_step, fn _overrides -> result end) == result
      end
    end
  end
end
