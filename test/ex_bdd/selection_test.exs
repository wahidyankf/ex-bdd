defmodule ExBdd.SelectionTest do
  use ExUnit.Case, async: false

  alias ExBdd.CorpusFixtures

  # @scenario specs/behaviours/selection.feature: mix test --only selects ExBdd scenarios by tag
  test "run_only/2 runs only the scenarios carrying the tag" do
    modules = CorpusFixtures.compile_selection()
    run = CorpusFixtures.run_only(modules, "feature_alpha_selection")

    assert {run.total - run.excluded, run.excluded} == {2, 1}
  end
end
