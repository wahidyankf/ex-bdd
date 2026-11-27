Feature: Runner outcomes for steps that error, pend, or have no binding

  # Behaviour: BH-46
  # Exemption(e2e): run outcomes are read only from the runner's result values; alternative-proof: test:integration
  @e2e-exempt
  Scenario: A step that returns an error fails its scenario
    When the sub-run "a step returns an error" runs
    Then the sub-run has 1 failure and 0 passed
    And the sub-run output contains "boom from the error step"

  # Behaviour: BH-47
  # Exemption(e2e): run outcomes are read only from the runner's result values; alternative-proof: test:integration
  @e2e-exempt
  Scenario: A step that returns pending fails its scenario and skips the rest
    When the sub-run "a step returns pending" runs
    Then the sub-run has 1 failure and 0 passed
    And the sub-run events are "pending_attempt"

  # Behaviour: BH-72
  # Exemption(e2e): run outcomes are read only from the runner's result values; alternative-proof: test:integration
  @e2e-exempt
  Scenario: A missing or an ambiguous step fails the run with its location
    When the sub-run "a missing and an ambiguous step" runs
    Then the sub-run has 2 failures and 0 passed
    And the sub-run output contains "No matching step definition"
    And the sub-run output contains "Ambiguous step"
    And the sub-run output contains "unbound_steps.feature:3"
    And the sub-run output contains "unbound_steps.feature:5"

  # Behaviour: BH-71
  # Exemption(e2e): run outcomes are read only from the runner's result values; alternative-proof: test:integration
  @e2e-exempt
  Scenario: A failing step shows its message, history, and stacktrace
    When the sub-run "a failing step after a passing one" runs
    Then the sub-run has 1 failure and 0 passed
    And the sub-run output contains "step raised on purpose"
    And the sub-run output contains "Step execution history:"
    And the sub-run output contains "[passed] Given a passing step"
    And the sub-run output contains "[failed] When a step that raises"
    And the sub-run output contains "stacktrace:"
