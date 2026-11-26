Feature: Error Reporting

Scenario: verify_features reports a step that has no binding
  When I verify the fixture feature "undefined.feature" with the fixture steps "steps.exs"
  Then verification fails with a message containing "has no matching binding"
