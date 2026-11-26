defmodule ExBdd.Gherkin.ParserUnitTest do
  use ExUnit.Case, async: true

  alias ExBdd.Gherkin.{ParseError, Parser}

  describe "parse/1" do
    test "a docstring delimiter where a step is expected is a parse error" do
      source = """
      Feature: f
        Scenario: s
          Given a step
          '''
          text
          '''
      """

      assert_raise ParseError, ~r/Expected a step, table row, doc string/, fn ->
        Parser.parse(source)
      end
    end

    test "a feature with no scenarios or rules has empty lists for both" do
      assert %{name: "empty", scenarios: [], rules: []} = Parser.parse("Feature: empty\n")
    end

    test "a background's steps are kept on the feature" do
      feature =
        Parser.parse("""
        Feature: f
          Background:
            Given a precondition
          Scenario: s
            Given a step
        """)

      assert %{background: %{steps: [%{text: "a precondition"}]}} = feature
    end

    test "text that is not Gherkin at all is a parse error" do
      assert_raise ParseError, ~r/Gherkin parse error/, fn ->
        Parser.parse("@@@ not gherkin\n")
      end
    end

    test "a feature description is kept on the feature" do
      feature =
        Parser.parse("""
        Feature: f
          As a tester
          I want coverage
          Scenario: s
            Given a step
        """)

      assert feature.description =~ "As a tester"
    end

    test "a feature line without a name parses to an empty name" do
      assert %{name: ""} = Parser.parse("Feature:\n  Scenario: s\n    Given a step\n")
    end

    test "a scenario line without a name parses to an empty name" do
      feature = Parser.parse("Feature: f\n  Scenario:\n    Given a step\n")

      assert [%{name: ""}] = feature.scenarios
    end
  end

  describe "feature names, tags, and the Markdown extension" do
    # credo:disable-for-next-line Credo.Check.Readability.MaxLineLength
    # @scenario specs/behaviours/gherkin_parse.feature: parse reads the feature name, tags, and scenarios of a feature text
    test "parse reads the feature name, tags, and scenarios of a feature text" do
      feature =
        Parser.parse("""
        @parsed
        Feature: Parsed feature
          Scenario: first
            Given a step
          Scenario: second
            Given another step
        """)

      assert feature.name == "Parsed feature"
      assert feature.tags == ["parsed"]
      assert Enum.map(feature.scenarios, & &1.name) == ["first", "second"]
    end

    # @scenario specs/behaviours/gherkin_parse.feature: parse reads a feature.md path as Markdown
    test "parse reads a feature.md path as Markdown" do
      feature =
        Parser.parse(
          "# Feature: Markdown parsed\n\n## Scenario: a heading scenario\n\n* Given a bullet step\n",
          "parsed.feature.md"
        )

      assert feature.name == "Markdown parsed"
      assert Enum.map(feature.scenarios, & &1.name) == ["a heading scenario"]
    end
  end
end
