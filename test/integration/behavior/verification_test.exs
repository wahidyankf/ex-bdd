defmodule ExBdd.Integration.VerificationTest do
  use ExUnit.Case, async: false
  @moduletag :integration

  # @scenario specs/behaviours/verification.feature: verify_features reads the feature and step files it is given
  test "verify_features reads the feature and step files it is given" do
    with_corpus(
      %{
        "valid.feature" =>
          "Feature: Verified on disk\n  Scenario: a verified scenario\n    Given a verified step\n    When it is checked\n    Then it passes\n",
        "steps.exs" =>
          steps_module("VerifiedSteps", ["a verified step", "it is checked", "it passes"])
      },
      fn dir ->
        result = verify(dir, "valid.feature", "steps.exs")

        assert result.feature_count == 1
        assert result.scenario_count == 1
        assert result.step_count == 3
      end
    )
  end

  # @scenario specs/behaviours/verification.feature: verify_features counts every Examples row of an outline
  test "verify_features counts every Examples row of an outline" do
    with_corpus(
      %{
        "outline.feature" =>
          "Feature: Outline on disk\n  Scenario Outline: adds <number>\n    Given a number <number>\n    When it is added\n    Then the total is counted\n\n    Examples:\n      | number |\n      | 1      |\n      | 2      |\n",
        "steps.exs" =>
          steps_module("OutlineSteps", ["a number {int}", "it is added", "the total is counted"])
      },
      fn dir ->
        result = verify(dir, "outline.feature", "steps.exs")

        assert result.scenario_count == 2
        assert result.step_count == 6
      end
    )
  end

  # @scenario specs/behaviours/verification.feature: verify_features rejects a corpus with no feature files
  test "verify_features rejects a corpus with no feature files" do
    with_corpus(%{"steps.exs" => steps_module("EmptyCorpusSteps", ["a step"])}, fn dir ->
      assert_raise ExBdd.VerificationError, ~r/No feature files/, fn ->
        ExBdd.verify_features!(
          features: [Path.join(dir, "missing/**/*.feature")],
          steps: [Path.join(dir, "steps.exs")],
          support: []
        )
      end
    end)
  end

  # @scenario specs/behaviours/verification.feature: verify_features rejects a feature without scenarios
  test "verify_features rejects a feature without scenarios" do
    with_corpus(
      %{
        "empty.feature" => "Feature: Empty on disk\n",
        "steps.exs" => steps_module("NoScenarioSteps", ["a step"])
      },
      fn dir ->
        assert_raise ExBdd.VerificationError, ~r/has no scenarios/, fn ->
          verify(dir, "empty.feature", "steps.exs")
        end
      end
    )
  end

  # @scenario specs/behaviours/verification.feature: verify_features requires an explicit When step
  test "verify_features requires an explicit When step" do
    with_corpus(
      %{
        "missing_when.feature" =>
          "Feature: Missing when on disk\n  Scenario: no action\n    Given a precondition\n    Then an outcome\n",
        "steps.exs" => steps_module("MissingWhenSteps", ["a precondition", "an outcome"])
      },
      fn dir ->
        assert_raise ExBdd.VerificationError, ~r/requires an explicit When/, fn ->
          verify(dir, "missing_when.feature", "steps.exs")
        end
      end
    )
  end

  # @scenario specs/behaviours/verification.feature: verify_features requires an explicit Then step
  test "verify_features requires an explicit Then step" do
    with_corpus(
      %{
        "missing_then.feature" =>
          "Feature: Missing then on disk\n  Scenario: no outcome\n    Given a precondition\n    When an action\n",
        "steps.exs" => steps_module("MissingThenSteps", ["a precondition", "an action"])
      },
      fn dir ->
        assert_raise ExBdd.VerificationError, ~r/requires an explicit Then/, fn ->
          verify(dir, "missing_then.feature", "steps.exs")
        end
      end
    )
  end

  # @scenario specs/behaviours/error_reporting.feature: verify_features reports a step that has no binding
  test "verify_features reports a step that has no binding" do
    with_corpus(
      %{
        "unbound.feature" =>
          "Feature: Unbound on disk\n  Scenario: a step nobody binds\n    Given a step nobody binds\n",
        "steps.exs" => steps_module("UnboundSteps", ["a different step"])
      },
      fn dir ->
        assert_raise ExBdd.VerificationError, ~r/has no matching binding/, fn ->
          verify(dir, "unbound.feature", "steps.exs")
        end
      end
    )
  end

  # @scenario specs/behaviours/verification.feature: verify_features rejects a step that two bindings match
  test "verify_features rejects a step that two bindings match" do
    with_corpus(
      %{
        "shared.feature" =>
          "Feature: Shared on disk\n  Scenario: a shared step\n    Given a shared step\n",
        "steps.exs" => steps_module("SharedSteps", ["a shared {word}", "a shared step"])
      },
      fn dir ->
        assert_raise ExBdd.VerificationError, ~r/matches 2 bindings/, fn ->
          verify(dir, "shared.feature", "steps.exs")
        end
      end
    )
  end

  # @scenario specs/behaviours/verification.feature: verify_features rejects a binding that no scenario uses
  test "verify_features rejects a binding that no scenario uses" do
    with_corpus(
      %{
        "used.feature" =>
          "Feature: Used on disk\n  Scenario: a used step\n    Given a used step\n",
        "steps.exs" => steps_module("UnusedSteps", ["a used step", "an unused step"])
      },
      fn dir ->
        assert_raise ExBdd.VerificationError, ~r/is not used/, fn ->
          verify(dir, "used.feature", "steps.exs")
        end
      end
    )
  end

  defp with_corpus(files, fun) do
    dir = Path.join(System.tmp_dir!(), "ex_bdd_verify_#{System.unique_integer([:positive])}")
    File.mkdir_p!(dir)

    try do
      Enum.each(files, fn {name, text} -> File.write!(Path.join(dir, name), text) end)
      fun.(dir)
    after
      File.rm_rf(dir)
    end
  end

  defp verify(dir, feature, steps) do
    ExBdd.verify_features!(
      features: [Path.join(dir, feature)],
      steps: [Path.join(dir, steps)],
      support: []
    )
  end

  defp steps_module(name, texts) do
    definitions =
      Enum.map_join(texts, "\n", fn text ->
        "  step \"#{text}\", _context do\n    :ok\n  end\n"
      end)

    "defmodule ExBdd.Integration.Verification.#{name} do\n  use ExBdd.StepDefinition\n\n#{definitions}end\n"
  end
end
