@counted-steps
Feature: Run-level hooks

Scenario: run-level context reaches every scenario
  Given the run-level setup has happened

Scenario: a before-step hook runs before each step of a tagged scenario
  Given the run-level setup has happened
  Then the global hooks step counter has counted this scenario's steps
