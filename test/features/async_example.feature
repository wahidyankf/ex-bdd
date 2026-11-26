@async
Feature: Async Feature Example
  This feature demonstrates running scenarios asynchronously

  Scenario: Steps of an async scenario share its context
    Given an async step
    When async work happens
    Then async work should complete
    And another async step
    And more async work happens
    And all async work should complete
