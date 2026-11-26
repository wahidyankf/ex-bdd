defmodule ExBdd.Gherkin.MarkdownUnitTest do
  use ExUnit.Case, async: true

  alias ExBdd.Gherkin.{Markdown, ParseError, Rule, Scenario, Step}

  describe "where a feature starts" do
    test "a first line that is not a Feature heading becomes the feature name" do
      feature = Markdown.parse("Plain title\n## Scenario: s\n* Given a step\n")

      assert feature.name == "Plain title"
    end

    test "a first line with another Gherkin keyword heading keeps the whole line as the name" do
      feature = Markdown.parse("# Scenario: early\n## Scenario: s\n* Given a step\n")

      assert feature.name == "# Scenario: early"
    end

    test "a GFM separator row before the feature is skipped" do
      feature = Markdown.parse("|---|---|\n# Feature: f\n## Scenario: s\n* Given a step\n")

      assert feature.name == "f"
    end

    test "a second Feature heading is ignored and the first name is kept" do
      feature = Markdown.parse("# Feature: one\n# Feature: two\n## Scenario: s\n* Given a step\n")

      assert feature.name == "one"
    end
  end

  describe "tags" do
    # credo:disable-for-next-line Credo.Check.Readability.MaxLineLength
    # @scenario specs/behaviours/gherkin_parse.feature: .feature.md headings at any level, fences, and inline-code tags parse
    test "a tag line before a scenario tags that scenario" do
      feature =
        Markdown.parse(
          Enum.join(
            ["# Feature: f", "`@wip` `@slow`", "## Scenario: s", "* Given a step"],
            "\n"
          )
        )

      assert [%Scenario{name: "s", tags: ["wip", "slow"]}] = feature.scenarios
    end
  end

  describe "rules" do
    test "each rule collects its own scenarios and closes when the next rule starts" do
      feature =
        Markdown.parse(
          Enum.join(
            [
              "# Feature: f",
              "## Rule: first",
              "### Scenario: one",
              "* Given a step",
              "## Rule: second",
              "### Scenario: two",
              "* Given another step"
            ],
            "\n"
          )
        )

      assert [
               %Rule{name: "first", scenarios: [%Scenario{name: "one"}]},
               %Rule{name: "second", scenarios: [%Scenario{name: "two"}]}
             ] = feature.rules

      assert feature.scenarios == []
    end

    test "a tag line before a rule tags that rule" do
      feature =
        Markdown.parse(
          Enum.join(
            ["# Feature: f", "`@slow`", "## Rule: r", "### Scenario: s", "* Given a step"],
            "\n"
          )
        )

      assert [%Rule{name: "r", tags: ["slow"]}] = feature.rules
    end

    test "a background inside a rule belongs to that rule, not the feature" do
      feature =
        Markdown.parse(
          Enum.join(
            [
              "# Feature: f",
              "## Rule: r",
              "## Background: setup",
              "* Given a precondition",
              "### Scenario: s",
              "* Given a step"
            ],
            "\n"
          )
        )

      assert feature.background == nil

      assert [%Rule{background: %{name: "setup", steps: [%Step{text: "a precondition"}]}}] =
               feature.rules
    end
  end

  describe "backgrounds" do
    test "a background keeps its steps in source order" do
      feature =
        Markdown.parse(
          Enum.join(
            [
              "# Feature: f",
              "## Background: setup",
              "* Given a first step",
              "* Given a second step",
              "## Scenario: s",
              "* Given a step"
            ],
            "\n"
          )
        )

      assert %{name: "setup", steps: [%Step{text: "a first step"}, %Step{text: "a second step"}]} =
               feature.background
    end

    test "a background after a scenario is rejected" do
      source =
        Enum.join(
          [
            "# Feature: f",
            "## Scenario: s",
            "* Given a step",
            "## Background: late",
            "* Given a step"
          ],
          "\n"
        )

      assert_raise ParseError, ~r/a single Background before the first Scenario/, fn ->
        Markdown.parse(source)
      end
    end

    test "a tag line before a background is rejected" do
      source =
        Enum.join(["# Feature: f", "`@wip`", "## Background: setup", "* Given a step"], "\n")

      assert_raise ParseError, ~r/no tags before a Background/, fn ->
        Markdown.parse(source)
      end
    end
  end

  describe "examples and outlines" do
    test "an Examples heading outside a scenario outline is rejected" do
      source =
        Enum.join(
          ["# Feature: f", "## Scenario: s", "* Given a step", "### Examples: rows", "  | a |"],
          "\n"
        )

      assert_raise ParseError, ~r/a Scenario Outline before an Examples table/, fn ->
        Markdown.parse(source)
      end
    end

    test "a step after an examples table is rejected" do
      source =
        Enum.join(
          [
            "# Feature: f",
            "## Scenario Outline: o",
            "* Given a <value>",
            "### Examples: values",
            "  | value |",
            "  | 1     |",
            "* Given a later step"
          ],
          "\n"
        )

      assert_raise ParseError, ~r/steps to come before the Examples tables/, fn ->
        Markdown.parse(source)
      end
    end
  end

  describe "tables" do
    test "a table row with no step before it is rejected" do
      source = Enum.join(["# Feature: f", "## Scenario: s", "  | a |"], "\n")

      assert_raise ParseError, ~r/a step or an Examples heading before a table row/, fn ->
        Markdown.parse(source)
      end
    end

    test "a table under a background step attaches its rows to that step" do
      feature =
        Markdown.parse(
          Enum.join(
            [
              "# Feature: f",
              "## Background: setup",
              "* Given a table",
              "  | x | y |",
              "  | 1 | 2 |",
              "## Scenario: s",
              "* Given a step"
            ],
            "\n"
          )
        )

      assert [%Step{datatable: [["x", "y"], ["1", "2"]]}] = feature.background.steps
    end
  end

  describe "docstrings" do
    test "a fence with no info string carries no media type" do
      feature =
        Markdown.parse(
          Enum.join(
            ["# Feature: f", "## Scenario: s", "* Given a document", "```", "hello", "```"],
            "\n"
          )
        )

      assert [%{steps: [%Step{docstring: "hello", docstring_media_type: nil}]}] =
               feature.scenarios
    end

    test "a content line indented less than its fence loses only its own indentation" do
      source =
        Enum.join(
          [
            "# Feature: f",
            "## Scenario: s",
            "* Given a document",
            "    ```text",
            "  short",
            "      long",
            "    ```"
          ],
          "\n"
        )

      feature = Markdown.parse(source)

      assert [%{steps: [%Step{docstring: "short\n  long", docstring_media_type: "text"}]}] =
               feature.scenarios
    end

    test "a fence outside any step is prose and adds no docstring" do
      feature =
        Markdown.parse(
          Enum.join(
            ["# Feature: f", "```", "some code", "```", "## Scenario: s", "* Given a step"],
            "\n"
          )
        )

      assert [%{steps: [%Step{docstring: nil}]}] = feature.scenarios
    end

    test "a second docstring for the same step is rejected" do
      source =
        Enum.join(
          [
            "# Feature: f",
            "## Scenario: s",
            "* Given a document",
            "```",
            "one",
            "```",
            "```",
            "two",
            "```"
          ],
          "\n"
        )

      assert_raise ParseError, ~r/a single docstring per step/, fn ->
        Markdown.parse(source)
      end
    end

    test "an unclosed fence is rejected at the end of the file" do
      source = Enum.join(["# Feature: f", "```", "never closed"], "\n")

      assert_raise ParseError, ~r/a closing ``` fence before the end of the file/, fn ->
        Markdown.parse(source)
      end
    end
  end
end
