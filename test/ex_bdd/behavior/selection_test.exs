defmodule ExBdd.Behavior.SelectionTest do
  @moduledoc """
  Behavior tests for `mix test --only` selection of ExBdd scenarios.

  `mix test --only <tag>` includes the tag and excludes every other test. These
  tests apply the same ExUnit filters in-process to modules compiled from two
  small features, and check which scenarios run. The command line itself is
  not exercised here.
  """

  use ExUnit.Case

  alias ExBdd.CorpusFixtures

  setup do
    {:ok, modules: CorpusFixtures.compile_selection()}
  end

  test "--only ex_bdd selects every generated scenario", %{modules: modules} do
    assert %{total: 3, failures: 0, excluded: 0} = CorpusFixtures.run_only(modules, "ex_bdd")
  end

  test "--only feature_<name> selects the scenarios of that feature alone", %{modules: modules} do
    assert %{total: 3, failures: 0, excluded: 1} =
             CorpusFixtures.run_only(modules, "feature_alpha_selection")

    assert %{total: 3, failures: 0, excluded: 2} =
             CorpusFixtures.run_only(modules, "feature_beta_selection")
  end

  test "a tag that no generated feature carries selects nothing", %{modules: modules} do
    assert %{total: 3, failures: 0, excluded: 3} =
             CorpusFixtures.run_only(modules, "feature_missing")
  end
end
