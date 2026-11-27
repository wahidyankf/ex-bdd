Feature: Simple feature

# Exemption(e2e): a plain step runs only through the runner API; alternative-proof: test:integration
@e2e-exempt
Scenario: Runs a simple step
  Given a simple step

# Exemption(e2e): a plain step runs only through the runner API; alternative-proof: test:integration
@e2e-exempt
Scenario: But steps run like And steps
  Given a simple step
  But a simple step
