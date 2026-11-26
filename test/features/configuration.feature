Feature: Configuration keys that set discovery paths

  Scenario: config features, steps, and support set the discovery paths
    When discovery runs with the config features, steps, and support set to fixtures
    Then discovery found 1 feature named "Strict verification"
    And discovery loaded the step module "ExBdd.VerificationFixtureSteps"
    And discovery loaded the support module "ExBdd.ConfigurationFixture.Hooks"
