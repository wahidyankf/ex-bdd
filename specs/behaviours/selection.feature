Feature: Selecting ExBdd scenarios with mix test --only

  # Behaviour: BH-73
  # Exemption(e2e): tag selection is the ExUnit filter the integration level runs; alternative-proof: test:integration
  @e2e-exempt
  Scenario: mix test --only selects ExBdd scenarios by tag
    Given two features are compiled for selection
    When the selection runs only the tag "ex_bdd"
    Then 3 scenarios run and 0 excluded
    When the selection runs only the tag "feature_alpha_selection"
    Then 2 scenarios run and 1 excluded
