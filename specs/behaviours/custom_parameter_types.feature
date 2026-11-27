Feature: Custom parameter types
  Custom parameter types registered in support files can be used
  in step patterns like the built-in types.

  # Exemption(e2e): parameter types are matched only through the expression API; alternative-proof: test:integration
  @e2e-exempt
  Scenario: a transformed route parameter
    Given flight LHR-CDG is boarding
    Then the flight departs from "LHR"
    And the flight arrives in "CDG"

  # Exemption(e2e): parameter types are matched only through the expression API; alternative-proof: test:integration
  @e2e-exempt
  Scenario: an untransformed enum parameter
    Given a task with high priority
    Then the recorded priority is "high"
