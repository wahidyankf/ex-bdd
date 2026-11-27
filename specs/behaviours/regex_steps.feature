Feature: Regular expression step definitions
  Steps can be implemented with regexes as well as cucumber expressions.

  # Exemption(e2e): regex captures reach a step only through the step matcher; alternative-proof: test:integration
  @e2e-exempt
  Scenario: regex captures arrive as strings
    Given a basket holding 3 apples and 2 pears
    Then the regex basket total is "5"

  # Exemption(e2e): regex captures reach a step only through the step matcher; alternative-proof: test:integration
  @e2e-exempt
  Scenario: optional regex groups are nil when absent
    Given a basket holding 4 apples
    Then the regex basket total is "4"
