defmodule ExBdd.Gherkin.TablesTest do
  use ExUnit.Case, async: true

  alias ExBdd.Gherkin.{Examples, Feature, Parser, ScenarioOutline, Tables}

  describe "cells/1" do
    test "returns no cells for a line without a pipe" do
      assert Tables.cells("no table here") == []
    end
  end

  describe "validate!/2" do
    test "accepts an examples block that has no header row" do
      outline = %ScenarioOutline{steps: [], examples: [%Examples{table_header: []}]}
      feature = %Feature{name: "headless", scenarios: [outline], rules: [], tags: []}

      assert Tables.validate!(feature, "") == feature
    end

    test "rejects a one-column row that is followed by a two-column row" do
      source = """
      Feature: ragged
        Scenario: ragged table
          Given a table
            | a |
            | b | c |
      """

      assert_raise ExBdd.Gherkin.ParseError, ~r/a table row with 1 cell to match/, fn ->
        Parser.parse(source)
      end
    end
  end
end
