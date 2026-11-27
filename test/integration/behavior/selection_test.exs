defmodule ExBdd.Integration.SelectionTest do
  use ExUnit.Case, async: false
  @moduletag :integration

  alias ExBdd.CorpusFixtures

  # @scenario specs/behaviours/selection.feature: mix test --only selects ExBdd scenarios by tag
  test "mix test --only selects ExBdd scenarios by tag" do
    dir = Path.join(System.tmp_dir!(), "ex_bdd_selection_#{System.unique_integer([:positive])}")
    File.mkdir_p!(dir)
    alpha = Path.join(dir, "alpha.feature")
    beta = Path.join(dir, "beta.feature")
    steps = Path.join(dir, "selection_steps.exs")

    try do
      File.write!(
        alpha,
        "Feature: Alpha selection\n  Scenario: first alpha\n    Given a selection step\n  Scenario: second alpha\n    Given a selection step\n"
      )

      File.write!(
        beta,
        "Feature: Beta selection\n  Scenario: the beta scenario\n    Given a selection step\n"
      )

      File.write!(
        steps,
        "defmodule ExBdd.Integration.SelectionSteps do\n  use ExBdd.StepDefinition\n\n  step \"a selection step\", _context do\n    :ok\n  end\nend\n"
      )

      modules = ExBdd.compile_features!(features: [alpha, beta], steps: [steps], support: [])

      everything = CorpusFixtures.run_only(modules, "ex_bdd")
      assert {everything.total - everything.excluded, everything.excluded} == {3, 0}

      alpha_only = CorpusFixtures.run_only(modules, "feature_alpha_selection")
      assert {alpha_only.total - alpha_only.excluded, alpha_only.excluded} == {2, 1}
    after
      File.rm_rf(dir)
    end
  end
end
