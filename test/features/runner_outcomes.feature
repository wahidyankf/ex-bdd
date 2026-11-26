Feature: Runner outcomes for steps that error, pend, or have no binding

  Scenario: A step that returns an error fails its scenario
    When the sub-run "a step returns an error" runs
    Then the sub-run has 1 failure and 0 passed
    And the sub-run output contains "boom from the error step"

  Scenario: A step that returns pending fails its scenario and skips the rest
    When the sub-run "a step returns pending" runs
    Then the sub-run has 1 failure and 0 passed
    And the sub-run events are "pending_attempt"

  Scenario: A missing or an ambiguous step fails the run with its location
    When the sub-run "a missing and an ambiguous step" runs
    Then the sub-run has 2 failures and 0 passed
    And the sub-run output contains "No matching step definition"
    And the sub-run output contains "Ambiguous step"
    And the sub-run output contains "unbound_steps.feature:3"
    And the sub-run output contains "unbound_steps.feature:5"
