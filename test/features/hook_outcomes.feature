Feature: Hook and step outcomes that skip a scenario or observe a step

  @skip-by-hook
  Scenario: A before hook that returns skipped leaves the steps unrun
    Given a step that must not run

  Scenario: A step that returns skipped ends its scenario without failing
    Given a step that skips the rest of its scenario
    Then a step that must not run

  @step-status
  Scenario: The after-step hook sees the status of a passing step
    Given a passing step

  Scenario: A before hook that returns pending or an error fails its scenario
    When the sub-run "a before hook returns pending or an error" runs
    Then the sub-run has 2 failures and 0 passed
    And the sub-run events do not include "step_ran"

  Scenario: A before_all that returns an error fails every scenario in the run
    When the sub-run "a before_all returns an error" runs
    Then the sub-run has 2 failures and 0 passed
    And the sub-run output contains "warm-up failed"
    And the sub-run events do not include "passing_step"

  Scenario: An after_all that raises fails the run after every after_all hook ran
    When the sub-run "an after_all raises" runs
    Then the sub-run raised "cleanup failed on purpose"
    And the sub-run events are "scenario_step; after_all_exploding; after_all_first"

  Scenario: The after_step hook sees failed, pending, and skipped steps
    When the sub-run "after_step hooks observe outcomes" runs
    Then the sub-run events include "{:after_step, :failed}"
    And the sub-run events include "{:after_step, :pending}"
    And the sub-run events include "{:after_step, :skipped}"

  Scenario: After hooks run after the steps, in reverse order
    When the sub-run "after hooks run in reverse after the steps" runs
    Then the sub-run has 0 failures and 1 passed
    And the sub-run events are "scenario_step; after_second; after_first"
