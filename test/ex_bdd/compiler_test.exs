defmodule ExBdd.CompilerTest do
  # Synchronous: the case-template tests below compile real test modules,
  # and a nested ExUnit run executes every module compiled since the
  # previous nested run anywhere in the suite — so compiling here must
  # stay out of the concurrent async phase and each compiled module must
  # be drained with run_isolated/1 in the same test.
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  alias ExBdd.Gherkin.{Feature, Scenario}

  describe "warn_on_empty_feature/1" do
    test "warns when the feature has zero scenarios" do
      feature = %Feature{name: "empty", scenarios: [], tags: []}
      feature = Map.put(feature, :file, "test/features/empty.feature")

      stderr = capture_io(:stderr, fn -> ExBdd.Compiler.warn_on_empty_feature(feature) end)

      assert stderr =~ "test/features/empty.feature"
      assert stderr =~ "zero scenarios"
    end

    test "is silent when the feature has at least one scenario" do
      feature = %Feature{
        name: "non-empty",
        scenarios: [%Scenario{name: "a", steps: [], tags: [], line: 1}],
        tags: []
      }

      feature = Map.put(feature, :file, "test/features/non_empty.feature")

      stderr = capture_io(:stderr, fn -> ExBdd.Compiler.warn_on_empty_feature(feature) end)

      assert stderr == ""
    end
  end

  defmodule MarkerCase do
    use ExUnit.CaseTemplate

    using do
      quote do
        def __ex_bdd_case_template__, do: :marker_case
      end
    end
  end

  describe "compile_feature!/4 with a case template" do
    test "uses the configured ExUnit case template" do
      feature = %Feature{
        name: "case template",
        scenarios: [%Scenario{name: "a scenario", steps: [], tags: [], line: 1}],
        tags: []
      }

      feature =
        Map.put(
          feature,
          :file,
          "test/features/case_template_#{System.unique_integer([:positive])}.feature"
        )

      registry = ExBdd.StepRegistry.new([], [])

      module = ExBdd.Compiler.compile_feature!(feature, registry, [], case_template: MarkerCase)

      assert function_exported?(module, :__ex_bdd_case_template__, 0)
      assert module.__ex_bdd_case_template__() == :marker_case
      assert function_exported?(module, :__step_registry__, 0)

      {result, _output} = ExBdd.BehaviorCase.run_isolated([module])
      assert result.total == 1
      assert result.failures == 0
    end

    test "generates a valid module for absolute paths with punctuation" do
      feature = %Feature{
        name: "absolute path",
        scenarios: [%Scenario{name: "a scenario", steps: [], tags: [], line: 1}],
        tags: []
      }

      feature =
        Map.put(
          feature,
          :file,
          Path.join([
            System.tmp_dir!(),
            "ex-bdd",
            "nested specs",
            "home-page_#{System.unique_integer([:positive])}.feature"
          ])
        )

      registry = ExBdd.StepRegistry.new([], [])

      module = ExBdd.Compiler.compile_feature!(feature, registry, [])

      assert is_atom(module)
      assert function_exported?(module, :__step_registry__, 0)

      {result, _output} = ExBdd.BehaviorCase.run_isolated([module])
      assert result.total == 1
      assert result.failures == 0
    end

    test "rejects a non-module case template" do
      feature = %Feature{name: "invalid case", scenarios: [], tags: []}
      feature = Map.put(feature, :file, "invalid_case.feature")

      registry = ExBdd.StepRegistry.new([], [])

      assert_raise ArgumentError, ~r/:case_template must be a module/, fn ->
        ExBdd.Compiler.compile_feature!(feature, registry, [], case_template: "ExUnit.Case")
      end
    end
  end

  describe "compile_discovery!/2" do
    test "compiles a discovery result with a custom case template" do
      feature = %Feature{
        name: "discovery template",
        scenarios: [%Scenario{name: "a scenario", steps: [], tags: [], line: 1}],
        tags: []
      }

      feature =
        Map.put(
          feature,
          :file,
          "test/features/discovery_template_#{System.unique_integer([:positive])}.feature"
        )

      discovery = %ExBdd.Discovery.DiscoveryResult{
        features: [feature],
        step_registry: ExBdd.StepRegistry.new([], []),
        hook_modules: []
      }

      [module] = ExBdd.Compiler.compile_discovery!(discovery, case_template: MarkerCase)

      assert function_exported?(module, :__ex_bdd_case_template__, 0)
      assert module.__ex_bdd_case_template__() == :marker_case

      {result, _output} = ExBdd.BehaviorCase.run_isolated([module])
      assert result.total == 1
      assert result.failures == 0
    end
  end
end
