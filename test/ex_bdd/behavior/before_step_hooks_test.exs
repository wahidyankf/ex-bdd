defmodule ExBdd.BeforeStepHooksTest do
  @moduledoc """
  Behavior tests for before_step hooks that fail, halt, or raise, for a thrown step
  under a retry tag, and for a binary attachment listed in failure output.
  """

  use ExBdd.BehaviorCase

  alias ExBdd.BehaviorCase.Collector

  defmodule Steps do
    use ExBdd.StepDefinition

    step "a step", _context do
      Collector.record(:step_ran)
      :ok
    end

    step "a step that throws", _context do
      Collector.record(:throw_attempt)
      throw(:oops)
    end

    step "a step that attaches a blob and fails", context do
      ExBdd.attach(context, {:bytes, <<1, 2, 3>>}, "application/octet-stream")
      raise "blob step failed"
    end
  end

  defmodule ErroringGate do
    use ExBdd.Hooks

    before_step _context, name: "gate" do
      Collector.record(:gate_ran)
      {:error, :boom}
    end
  end

  defmodule HaltingGate do
    use ExBdd.Hooks

    before_step _context do
      Collector.record(:halt_gate_ran)
      :pending
    end
  end

  defmodule ThrowingGate do
    use ExBdd.Hooks

    before_step _context do
      Collector.record(:throwing_gate)
      throw(:gate_oops)
    end
  end

  defmodule RaisingGate do
    use ExBdd.Hooks

    before_step _context, name: "raiser" do
      raise "gate exploded"
    end
  end

  @plain_scenario """
  Feature: gate
    Scenario: gated
      Given a step
  """

  describe "before_step hooks that fail" do
    test "an error from a before_step hook fails the step without running its body" do
      run = run_feature(@plain_scenario, steps: [Steps], hooks: [ErroringGate])

      assert %{total: 1, failures: 1} = run
      assert run.output =~ "Before step hook \"gate\" failed: :boom"
      assert count(run.events, :gate_ran) == 1
      refute :step_ran in run.events
    end

    test "a pending signal from a before_step hook halts the step" do
      run = run_feature(@plain_scenario, steps: [Steps], hooks: [HaltingGate])

      assert %{total: 1, failures: 1} = run
      assert count(run.events, :halt_gate_ran) == 1
      refute :step_ran in run.events
    end

    test "an exception from a before_step hook fails the scenario with that exception" do
      run = run_feature(@plain_scenario, steps: [Steps], hooks: [RaisingGate])

      assert %{total: 1, failures: 1} = run
      assert run.output =~ "gate exploded"
      refute :step_ran in run.events
    end
  end

  describe "retries" do
    test "a thrown step value is retried like an error under a retry tag" do
      run =
        run_feature(
          """
          Feature: throws
            @retry-1
            Scenario: throws
              Given a step that throws
          """,
          steps: [Steps]
        )

      assert %{total: 1, failures: 1} = run
      assert count(run.events, :throw_attempt) == 2
    end
  end

  describe "retries of a before_step hook that throws" do
    test "a thrown value from a before_step hook is retried under a retry tag" do
      run =
        run_feature(
          """
          Feature: gate throws
            @retry-1
            Scenario: gate throws
              Given a step
          """,
          steps: [Steps],
          hooks: [ThrowingGate]
        )

      assert %{total: 1, failures: 1} = run
      assert count(run.events, :throwing_gate) == 2
      refute :step_ran in run.events
    end
  end

  describe "attachments in failure output" do
    test "a binary attachment is listed by its media type, size, and encoding" do
      run =
        run_feature(
          """
          Feature: blob
            Scenario: blob
              Given a step that attaches a blob and fails
          """,
          steps: [Steps]
        )

      assert %{total: 1, failures: 1} = run
      assert run.output =~ "application/octet-stream: 3 bytes, base64-encoded"
    end
  end
end
