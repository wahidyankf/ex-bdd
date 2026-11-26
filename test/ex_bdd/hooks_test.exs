defmodule ExBdd.HooksTest do
  use ExUnit.Case, async: true

  describe "duplicate hook detection" do
    test "raises CompileError when defining duplicate tagged hooks" do
      code = """
      defmodule DuplicateTaggedHooks do
        use ExBdd.Hooks

        before_scenario "@database", context do
          {:ok, context}
        end

        before_scenario "@database", context do
          {:ok, context}
        end
      end
      """

      assert_raise CompileError, ~r/Duplicate hook: before_scenario_database/, fn ->
        Code.compile_string(code)
      end
    end

    test "raises CompileError when defining duplicate global hooks" do
      code = """
      defmodule DuplicateGlobalHooks do
        use ExBdd.Hooks

        before_scenario context do
          {:ok, context}
        end

        before_scenario context do
          {:ok, context}
        end
      end
      """

      assert_raise CompileError, ~r/Duplicate hook: before_scenario_global/, fn ->
        Code.compile_string(code)
      end
    end

    test "allows different tags without error" do
      code = """
      defmodule DifferentTagsHooks do
        use ExBdd.Hooks

        before_scenario "@database", context do
          {:ok, context}
        end

        before_scenario "@admin", context do
          {:ok, context}
        end
      end
      """

      # Should compile without error
      assert [{DifferentTagsHooks, _}] = Code.compile_string(code)
    end
  end

  describe "hook filtering and execution" do
    test "filter_hooks returns global hooks and hooks matching tags" do
      defmodule FilterTestModule do
        def global_hook(context), do: {:ok, context}
        def database_hook(context), do: {:ok, context}
        def special_hook(context), do: {:ok, context}
      end

      hooks = [
        {:before_scenario, nil, nil, {FilterTestModule, :global_hook}},
        {:before_scenario, "@database", nil, {FilterTestModule, :database_hook}},
        {:before_scenario, "@special", nil, {FilterTestModule, :special_hook}}
      ]

      # With ["database"] tags, should get global + @database hooks
      filtered = ExBdd.Hooks.filter_hooks(hooks, :before_scenario, ["database"])
      assert length(filtered) == 2

      # With ["database", "special"] tags, should get all 3 hooks
      filtered_all = ExBdd.Hooks.filter_hooks(hooks, :before_scenario, ["database", "special"])
      assert length(filtered_all) == 3

      # With [] tags, should only get global hook
      filtered_empty = ExBdd.Hooks.filter_hooks(hooks, :before_scenario, [])
      assert length(filtered_empty) == 1
    end

    test "run_before_hooks runs the given hook steps in order, threading the context" do
      defmodule RunTestModule do
        def hook_a(context), do: {:ok, Map.put(context, :order, [:a])}
        def hook_b(context), do: {:ok, Map.update!(context, :order, &(&1 ++ [:b]))}
      end

      # Tag selection happens when the test case is built (see
      # ExBdd.TestCaseTest); the hooks module runs what it is given
      {:ok, result} =
        ExBdd.Hooks.run_before_hooks(
          hook_steps([{RunTestModule, :hook_a}, {RunTestModule, :hook_b}]),
          %{}
        )

      assert result.order == [:a, :b]
    end

    test "run_before_hooks accepts keyword list return values" do
      defmodule KeywordReturnModule do
        def keyword_hook(_context), do: [db_ready: true, cache: :warm]
      end

      {:ok, result} =
        ExBdd.Hooks.run_before_hooks(hook_steps([{KeywordReturnModule, :keyword_hook}]), %{})

      assert result.db_ready == true
      assert result.cache == :warm
    end

    test "run_before_hooks raises on invalid return values" do
      defmodule InvalidReturnModule do
        def bad_hook(_context), do: :something_wrong
      end

      assert_raise RuntimeError, ~r/Invalid hook return value/, fn ->
        ExBdd.Hooks.run_before_hooks(hook_steps([{InvalidReturnModule, :bad_hook}]), %{})
      end
    end
  end

  defp hook_steps(refs) do
    refs
    |> Enum.with_index()
    |> Enum.map(fn {ref, position} ->
      %ExBdd.TestCase.HookStep{position: position, name: nil, ref: ref}
    end)
  end

  describe "collect_hooks/1" do
    test "loads modules that are compiled into the application but not yet loaded" do
      # Hook modules under test/support (or any compiled application) are
      # loaded lazily; collect_hooks must not silently drop a module the
      # code server hasn't loaded yet. ExBdd.ReloadableHooks exists only
      # for this test — unload it to reproduce the pre-load state.
      {:module, module} = Code.ensure_loaded(ExBdd.ReloadableHooks)
      :code.purge(module)
      :code.delete(module)
      :code.purge(module)
      refute :erlang.module_loaded(module)

      assert [{:before_scenario, nil, nil, {^module, _fun}}] =
               ExBdd.Hooks.collect_hooks([module])
    end
  end

  defmodule NamedStepHooks do
    use ExBdd.Hooks

    before_step ctx, name: "prep" do
      ctx
    end

    before_step "@wip", ctx, name: "tagged prep" do
      ctx
    end

    after_step ctx, name: "tidy" do
      ctx
    end

    after_step "@slow", ctx, name: "tagged tidy" do
      ctx
    end
  end

  defmodule OutcomeHooks do
    def fail(_context), do: {:error, :boom}
    def skip(_context), do: {:skipped, "not today"}
    def merge(_context), do: %{merged: true}

    def record(context) do
      send(self(), {:ran, context})
      :ok
    end
  end

  describe "named before_step and after_step hooks" do
    test "each hook records its type, optional tag, and name" do
      assert [
               {:before_step, nil, "prep", {NamedStepHooks, _}},
               {:before_step, "@wip", "tagged prep", {NamedStepHooks, _}},
               {:after_step, nil, "tidy", {NamedStepHooks, _}},
               {:after_step, "@slow", "tagged tidy", {NamedStepHooks, _}}
             ] = NamedStepHooks.__ex_bdd_hooks__()
    end

    test "a hook name that is not a non-empty string raises at compile time" do
      assert_raise CompileError,
                   ~r/Hook name for before_step must be a non-empty string, got: 123/,
                   fn ->
                     defmodule BadNamedHooks do
                       use ExBdd.Hooks

                       before_step ctx, name: 123 do
                         ctx
                       end
                     end
                   end
    end

    test "two hooks with the same name in one module raise at compile time" do
      assert_raise CompileError,
                   ~r/Duplicate hook: before_step_named_same already defined for name "same"/,
                   fn ->
                     defmodule DuplicateNamedHooks do
                       use ExBdd.Hooks

                       before_step ctx, name: "same" do
                         ctx
                       end

                       before_step ctx, name: "same" do
                         ctx
                       end
                     end
                   end
    end
  end

  describe "run_before_hooks/3 outcomes" do
    test "an error stops the chain and names the failing hook" do
      steps = [
        %{name: "first", ref: {OutcomeHooks, :fail}},
        %{name: "second", ref: {OutcomeHooks, :record}}
      ]

      assert {:error, :boom, "first"} = ExBdd.Hooks.run_before_hooks(steps, %{})
      refute_received {:ran, _}
    end

    test "a skip with a reason halts the chain with that reason" do
      steps = [
        %{name: "skip", ref: {OutcomeHooks, :skip}},
        %{name: "second", ref: {OutcomeHooks, :record}}
      ]

      assert {:halted, :skipped, "not today"} = ExBdd.Hooks.run_before_hooks(steps, %{})
      refute_received {:ran, _}
    end

    test "a map result is merged into the context the next hook receives" do
      steps = [
        %{name: "merge", ref: {OutcomeHooks, :merge}},
        %{name: "record", ref: {OutcomeHooks, :record}}
      ]

      assert {:ok, %{merged: true}} = ExBdd.Hooks.run_before_hooks(steps, %{})
      assert_received {:ran, %{merged: true}}
    end
  end

  describe "run_after_hooks/2" do
    test "runs each hook with the context and ignores what it returns" do
      steps = [%{name: "record", ref: {OutcomeHooks, :record}}]

      assert :ok = ExBdd.Hooks.run_after_hooks(steps, %{value: 1})
      assert_received {:ran, %{value: 1}}
    end
  end
end
