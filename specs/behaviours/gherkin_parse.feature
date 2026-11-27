Feature: Parsing Gherkin text

# Exemption(e2e): parser output is an Elixir value reached only via Parser.parse; alternative-proof: test:integration
@e2e-exempt
Scenario: parse reads the feature name, tags, and scenarios of a feature text
  Given this Gherkin text:
    """
    @parsed
    Feature: Parsed feature
      Scenario: first
        Given a step
      Scenario: second
        Given another step
    """
  When the parser reads the text
  Then the parsed feature is named "Parsed feature" with 2 scenarios
  And the parsed feature has the tag "parsed"

# Exemption(e2e): parser output is an Elixir value reached only via Parser.parse; alternative-proof: test:integration
@e2e-exempt
Scenario: parse reports a malformed table row with its path and line
  Given this Gherkin text:
    """
    Feature: Malformed table
      Scenario: short row
        Given a table:
          | a | b |
          | only one |
    """
  When the parser reads the text as "broken.feature"
  Then the parser raises a parse error whose message starts with "Gherkin parse error at broken.feature:5:7"

# Exemption(e2e): parser output is an Elixir value reached only via Parser.parse; alternative-proof: test:integration
@e2e-exempt
Scenario: parse reads a feature.md path as Markdown
  Given this Markdown text:
    """
    # Feature: Markdown parsed

    ## Scenario: a heading scenario

    * Given a bullet step
    """
  When the parser reads the text as "parsed.feature.md"
  Then the parsed feature is named "Markdown parsed" with 1 scenario

  # Exemption(e2e): parser output is an Elixir value reached only via Parser.parse; alternative-proof: test:integration
  @e2e-exempt
  Scenario: .feature.md headings at any level, fences, and inline-code tags parse
    Given this Markdown text:
      """
      `@md-tagged`
      # Feature: Heading levels

      ##### Scenario: a heading at level five

      * Given a step with a fenced docstring
      ```text
      body of the docstring
      ```
      """
    When the parser reads the text as "headings.feature.md"
    Then the parsed feature is named "Heading levels" with 1 scenario
    And the parsed feature has the tag "md-tagged"
