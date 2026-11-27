@track_execution
Feature: Hook Execution Order
  To verify hooks run in the correct order

  Background:
    Given I record "background_step"

  # Exemption(e2e): hook order is observed only through the hook API calls; alternative-proof: test:integration
  @e2e-exempt
  Scenario: Verify execution order
    When I record "scenario_step"
    Then the execution order should be "feature_hook,background_step,scenario_step"

  # Exemption(e2e): hook order is observed only through the hook API calls; alternative-proof: test:integration
  @e2e-exempt
  Scenario: A global before-scenario hook runs for every scenario
    Given the global before hook has run

  @named-hooks
  # Exemption(e2e): hook order is observed only through the hook API calls; alternative-proof: test:integration
  @e2e-exempt
  Scenario: Named hooks of the same kind all run
    Given the named hooks have run
