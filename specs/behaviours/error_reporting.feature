Feature: Error Reporting

# Behaviour: BH-09
# Exemption(e2e): verify_features reports only through ExBdd.verify_features!; alternative-proof: test:integration
@e2e-exempt
Scenario: verify_features reports a step that has no binding
  When I verify the fixture feature "undefined.feature" with the fixture steps "steps.exs"
  Then verification fails with a message containing "has no matching binding"
