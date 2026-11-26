Feature: Retrying flaky scenarios

@retry-1
Scenario: a flaky scenario eventually passes
  Given a flaky step that passes on the second attempt

@retry-1
Scenario: a retried attempt is numbered from one
  Given a step that fails only on its first attempt

  Scenario: A retry limit set in config applies to a scenario with no retry tag
    When the sub-run "a retry limit set in config" runs
    Then the sub-run has 0 failures and 1 passed
    And the sub-run events are "attempt; attempt; attempt"

  Scenario: Undefined, ambiguous, and pending scenarios are not retried under a config limit
    When the sub-run "undefined, ambiguous, and pending scenarios under a retry limit" runs
    Then the sub-run has 3 failures and 0 passed
    And the sub-run events are "pending_attempt"
    And the sub-run output does not contain "ExBdd: retrying scenario"
