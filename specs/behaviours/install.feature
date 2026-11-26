Feature: Installing ExBdd with mix ex_bdd.install

  Scenario: mix ex_bdd.install wires test_helper.exs and mix.exs
    When the ex_bdd.install task runs on a new project
    Then test_helper.exs calls ExBdd.compile_features!
    And mix.exs points its test paths at the step definitions and support
