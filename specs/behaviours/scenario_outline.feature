Feature: Scenario Outline Support

  # Exemption(e2e): outline expansion reaches a run only through the parser; alternative-proof: test:integration
  @e2e-exempt
  Scenario Outline: Adding numbers
    Given I have number <a>
    And I have number <b>
    When I add the numbers
    Then the result should be <sum>

    Examples:
      | a | b | sum |
      | 1 | 2 | 3   |
      | 5 | 3 | 8   |

    Examples: larger numbers
      | a  | b  | sum |
      | 10 | 20 | 30  |

  @tagged-outline
  # Exemption(e2e): outline expansion reaches a run only through the parser; alternative-proof: test:integration
  @e2e-exempt
  Scenario Outline: Tagged example
    Given I have value <value>
    Then I see result <result>

    @smoke
    Examples: smoke tests
      | value | result |
      | foo   | FOO    |

    @regression
    Examples: regression tests
      | value | result |
      | bar   | BAR    |
