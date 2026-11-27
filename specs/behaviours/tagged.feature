@feature-tag
Feature: Tags demonstration

# Behaviour: BH-19
@smoke
# Exemption(e2e): tag-gated hooks reach a scenario only through the hook API; alternative-proof: test:integration
@e2e-exempt
Scenario: a before hook for the smoke tag runs for a smoke scenario
  Given a simple smoke test
  Then the smoke tag hook has run

# Behaviour: BH-19
@regression
# Exemption(e2e): tag-gated hooks reach a scenario only through the hook API; alternative-proof: test:integration
@e2e-exempt
Scenario: a before hook for the regression tag runs for a regression scenario
  Given a regression test
  Then the regression tag hook has run

# Behaviour: BH-19
@smoke @regression
# Exemption(e2e): tag-gated hooks reach a scenario only through the hook API; alternative-proof: test:integration
@e2e-exempt
Scenario: both tag hooks run for a scenario with both tags
  Given a test with multiple tags
  Then the smoke tag hook has run
  And the regression tag hook has run

# Behaviour: BH-19
# Exemption(e2e): tag-gated hooks reach a scenario only through the hook API; alternative-proof: test:integration
@e2e-exempt
Scenario: tag hooks do not run for an untagged scenario
  Given an untagged test
  Then the smoke tag hook has not run
  And the regression tag hook has not run
