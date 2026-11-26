defmodule ExBdd.Integration.Gherkin.MarkdownHeadingsTest do
  use ExUnit.Case, async: true
  @moduletag :integration

  alias ExBdd.Gherkin.{Feature, Parser, Scenario}

  # credo:disable-for-next-line Credo.Check.Readability.MaxLineLength
  # @scenario specs/behaviours/gherkin_parse.feature: .feature.md headings at any level, fences, and inline-code tags parse
  test "headings at any level, fences, and inline-code tags parse" do
    markdown =
      Enum.join(
        [
          "## Feature: Headings at depth",
          "",
          "`@smoke`",
          "### Scenario: a deep heading",
          "",
          "* Given a step with a fenced docstring",
          "",
          "```text",
          "hello",
          "```",
          ""
        ],
        "\n"
      )

    assert %Feature{
             name: "Headings at depth",
             scenarios: [%Scenario{name: "a deep heading", tags: ["smoke"]}]
           } =
             Parser.parse(markdown, "headings.feature.md")
  end
end
