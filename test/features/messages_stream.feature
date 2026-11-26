Feature: Cucumber Messages output

  Scenario: ExBdd.Messages builders produce Cucumber Messages envelopes
    When the Messages builders make a test run started envelope for "run-1"
    Then the built envelope is a testRunStarted envelope for "run-1"
    When the sub-run "a run with messages" runs
    Then the sub-run messages include an envelope "testRunStarted"
    And the sub-run messages include an envelope "testRunFinished"

  Scenario: config messages writes the Cucumber Messages stream
    When the features compile and run with the messages config
    Then the messages config file holds a testRunStarted envelope
