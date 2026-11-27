Feature: Descriptions and docstring delimiters
  Free-form description text can follow any section header.
  This feature exercises descriptions at every level, plus both
  docstring delimiters and media type annotations.

  Background:
    Background sections can carry descriptions too.

    Given a noted base value "carrot"

  # Exemption(e2e): descriptions reach a parsed feature only through Parser.parse; alternative-proof: test:integration
  @e2e-exempt
  Scenario: standard docstring under a described scenario
    Descriptions under scenarios are plain prose —
    they should never execute as steps.

    When I note this docstring:
      """
      hello from triple quotes
      """
    Then the noted docstring is "hello from triple quotes"
    And the noted docstring has no media type

  # Exemption(e2e): descriptions reach a parsed feature only through Parser.parse; alternative-proof: test:integration
  @e2e-exempt
  Scenario: backtick docstring with a media type
    Backticks can also be used, like Markdown.

    When I note this docstring:
      ```json
      {"vegetable": "carrot"}
      ```
    Then the noted docstring contains "vegetable"
    And the noted docstring media type is "json"

  # Exemption(e2e): descriptions reach a parsed feature only through Parser.parse; alternative-proof: test:integration
  @e2e-exempt
  Scenario Outline: outlines can be described as well
    The outline description.

    When I note the word <word>
    Then the noted word is "<word>"

    Examples: some words
      Examples tables can be described as well.

      | word   |
      | apple  |
      | banana |
