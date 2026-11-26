Feature: Database Example
  Demonstrates selective database setup using hooks

# Exemption(e2e): tag hooks reach a scenario only through the hook API; alternative-proof: test:integration
@e2e-exempt
Scenario: Without database tag
  Given a step that checks database setup
  Then database should not be setup

@database
# Exemption(e2e): tag hooks reach a scenario only through the hook API; alternative-proof: test:integration
@e2e-exempt
Scenario: With database tag
  Given a step that checks database setup
  Then database should be setup