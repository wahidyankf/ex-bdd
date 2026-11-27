Feature: Configuration keys that set discovery paths

  # Behaviour: BH-69
  # Exemption(e2e): discovery paths are read only through ExBdd.Discovery options; alternative-proof: test:integration
  @e2e-exempt
  Scenario: config features, steps, and support set the discovery paths
    When discovery runs with the config features, steps, and support set to fixtures
    Then discovery found 1 feature named "Strict verification"
    And discovery loaded the step module "ExBdd.VerificationFixtureSteps"
    And discovery loaded the support module "ExBdd.ConfigurationFixture.Hooks"
