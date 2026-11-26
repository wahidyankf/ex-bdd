@feature-tag
Feature: Tags demonstration

@smoke
Scenario: a before hook for the smoke tag runs for a smoke scenario
  Given a simple smoke test
  Then the smoke tag hook has run

@regression
Scenario: a before hook for the regression tag runs for a regression scenario
  Given a regression test
  Then the regression tag hook has run

@smoke @regression
Scenario: both tag hooks run for a scenario with both tags
  Given a test with multiple tags
  Then the smoke tag hook has run
  And the regression tag hook has run

Scenario: tag hooks do not run for an untagged scenario
  Given an untagged test
  Then the smoke tag hook has not run
  And the regression tag hook has not run
