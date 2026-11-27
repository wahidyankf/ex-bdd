@counted-steps
Feature: Run-level hooks

# Behaviour: BH-51
# Exemption(e2e): run-level hooks reach scenarios only through the hook API; alternative-proof: test:integration
@e2e-exempt
Scenario: run-level context reaches every scenario
  Given the run-level setup has happened

# Behaviour: BH-54
# Exemption(e2e): run-level hooks reach scenarios only through the hook API; alternative-proof: test:integration
@e2e-exempt
Scenario: a before-step hook runs before each step of a tagged scenario
  Given the run-level setup has happened
  Then the global hooks step counter has counted this scenario's steps
