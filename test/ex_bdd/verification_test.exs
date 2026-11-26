defmodule ExBdd.VerificationTest do
  use ExUnit.Case, async: false

  @fixture_root Path.expand("../fixtures/verification", __DIR__)

  # @scenario specs/behaviours/verification.feature: verify_features reads the feature and step files it is given
  test "verifies and counts the complete expanded corpus" do
    result =
      ExBdd.verify_features!(
        features: [Path.join(@fixture_root, "valid.feature")],
        steps: [Path.join(@fixture_root, "steps.exs")],
        support: []
      )

    assert result.feature_count == 1
    assert result.scenario_count == 1
    assert result.step_count == 3
    assert result.binding_count == 3
  end

  # @scenario specs/behaviours/verification.feature: verify_features counts every Examples row of an outline
  test "counts every scenario-outline row and its steps" do
    result = verify("outline.feature", "steps.exs")

    assert result.scenario_count == 2
    assert result.step_count == 6
  end

  # @scenario specs/behaviours/verification.feature: verify_features rejects a corpus with no feature files
  test "rejects an empty feature corpus" do
    assert_verification_error("No feature files", fn ->
      ExBdd.verify_features!(
        features: [Path.join(@fixture_root, "missing/**/*.feature")],
        steps: [Path.join(@fixture_root, "steps.exs")],
        support: []
      )
    end)
  end

  # @scenario specs/behaviours/verification.feature: verify_features rejects a feature without scenarios
  test "rejects a feature without scenarios" do
    assert_verification_error("has no scenarios", fn -> verify("empty.feature", "steps.exs") end)
  end

  test "rejects scenarios that expand to no executable examples" do
    assert_verification_error("expands to no executable scenarios", fn ->
      verify("unexpanded.feature", "steps.exs")
    end)
  end

  # @scenario specs/behaviours/verification.feature: verify_features requires an explicit When step
  test "rejects scenarios without an explicit When" do
    assert_verification_error("requires an explicit When", fn ->
      verify("missing_when.feature", "steps.exs")
    end)
  end

  # @scenario specs/behaviours/verification.feature: verify_features requires an explicit Then step
  test "rejects scenarios without an explicit Then" do
    assert_verification_error("requires an explicit Then", fn ->
      verify("missing_then.feature", "steps.exs")
    end)
  end

  # @scenario specs/behaviours/error_reporting.feature: verify_features reports a step that has no binding
  test "rejects undefined steps" do
    assert_verification_error("has no matching binding", fn ->
      verify("undefined.feature", "steps.exs")
    end)
  end

  # @scenario specs/behaviours/verification.feature: verify_features rejects a step that two bindings match
  test "rejects ambiguous steps" do
    assert_verification_error("matches 2 bindings", fn ->
      verify("valid.feature", "ambiguous_steps.exs")
    end)
  end

  # @scenario specs/behaviours/verification.feature: verify_features rejects a binding that no scenario uses
  test "rejects unused bindings" do
    assert_verification_error("is not used", fn ->
      verify("valid.feature", "unused_steps.exs")
    end)
  end

  test "compile_features!/1 does not require a strictly verified corpus" do
    # Standalone 1.1.1 behavior is kept: compilation succeeds where strict
    # verification fails (the live suite itself has Given-only scenarios),
    # so undefined steps fail at runtime instead of refusing to compile.
    # The module is run here too: a nested run executes every suite module
    # compiled since the previous nested run, so each compiling test drains
    # its own modules in the same test.
    [module] =
      ExBdd.compile_features!(
        features: [Path.join(@fixture_root, "missing_when.feature")],
        steps: [Path.join(@fixture_root, "steps.exs")],
        support: []
      )

    assert is_atom(module)

    {result, _output} = ExBdd.BehaviorCase.run_isolated([module])
    assert result.total == 1
    assert result.failures == 0
  end

  test "verify_features!/1 rejects a Given-only scenario in the Markdown fixture" do
    assert_verification_error("requires an explicit", fn ->
      ExBdd.verify_features!(
        features: ["test/fixtures/markdown/markdown.feature.md"],
        steps: ["test/features/step_definitions/markdown_steps.exs"],
        support: []
      )
    end)
  end

  test "the public compiler returns executable modules for a valid corpus" do
    [module] =
      ExBdd.compile_features!(
        features: [Path.join(@fixture_root, "valid.feature")],
        steps: [Path.join(@fixture_root, "steps.exs")],
        support: []
      )

    {result, _output} = ExBdd.BehaviorCase.run_isolated([module])

    assert result.total == 1
    assert result.failures == 0
  end

  defp verify(feature, steps) do
    ExBdd.verify_features!(
      features: [Path.join(@fixture_root, feature)],
      steps: [Path.join(@fixture_root, steps)],
      support: []
    )
  end

  defp assert_verification_error(expected, fun) do
    result =
      try do
        fun.()
        :no_error
      rescue
        error -> error
      end

    refute result == :no_error
    assert result.__struct__ == ExBdd.VerificationError
    assert Exception.message(result) =~ expected
  end
end
