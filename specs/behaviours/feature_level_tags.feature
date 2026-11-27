@database
Feature: Feature Level Tag Support
  As a developer
  I want to use feature-level tags like @database
  So that hooks run before background steps

  Background:
    Given the database is initialized

  # Behaviour: BH-18
  # Behaviour: BH-21
  # Exemption(e2e): feature tags reach scenarios only through the compile API; alternative-proof: test:integration
  @e2e-exempt
  Scenario: First scenario uses database
    When I query the database
    Then I should get results

  # Behaviour: BH-18
  @special
  # Exemption(e2e): feature tags reach scenarios only through the compile API; alternative-proof: test:integration
  @e2e-exempt
  Scenario: Second scenario with additional tag
    When I query the database with special permissions
    Then I should get special results