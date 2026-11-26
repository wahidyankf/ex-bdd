Feature: Selecting ExBdd scenarios with mix test --only

  Scenario: mix test --only selects ExBdd scenarios by tag
    Given two features are compiled for selection
    When the selection runs only the tag "ex_bdd"
    Then 3 scenarios run and 0 excluded
    When the selection runs only the tag "feature_alpha_selection"
    Then 2 scenarios run and 1 excluded
