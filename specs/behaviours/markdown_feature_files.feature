Feature: Markdown feature files

  # Behaviour: BH-35
  # Behaviour: BH-75
  Scenario: feature files written in Markdown are discovered and their scenarios run like plain ones
    Given a Markdown feature file with a scenario and an outline with a table
    When it is discovered alongside a plain feature file
    Then the discovered features include the Markdown feature file
    And the sub-run "a Markdown feature file" runs
    And the sub-run records 5 fixture steps
