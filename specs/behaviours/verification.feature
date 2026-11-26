Feature: Verifying a feature corpus

# Exemption(e2e): verification reads its inputs only through verify_features!; alternative-proof: test:integration
@e2e-exempt
Scenario: verify_features reads the feature and step files it is given
  When I verify the fixture feature "valid.feature" with the fixture steps "steps.exs"
  Then the verification counts are 1 feature, 1 scenario, and 3 steps
  And the verification has 3 bindings

# Exemption(e2e): verification reads its inputs only through verify_features!; alternative-proof: test:integration
@e2e-exempt
Scenario: verify_features counts every Examples row of an outline
  When I verify the fixture feature "outline.feature" with the fixture steps "steps.exs"
  Then the verification counts are 1 feature, 2 scenarios, and 6 steps

# Exemption(e2e): verification reads its inputs only through verify_features!; alternative-proof: test:integration
@e2e-exempt
Scenario: verify_features rejects a corpus with no feature files
  When I verify the fixture feature "missing/**/*.feature" with the fixture steps "steps.exs"
  Then verification fails with a message containing "No feature files"

# Exemption(e2e): verification reads its inputs only through verify_features!; alternative-proof: test:integration
@e2e-exempt
Scenario: verify_features rejects a feature without scenarios
  When I verify the fixture feature "empty.feature" with the fixture steps "steps.exs"
  Then verification fails with a message containing "has no scenarios"

# Exemption(e2e): verification reads its inputs only through verify_features!; alternative-proof: test:integration
@e2e-exempt
Scenario: verify_features requires an explicit When step
  When I verify the fixture feature "missing_when.feature" with the fixture steps "steps.exs"
  Then verification fails with a message containing "requires an explicit When"

# Exemption(e2e): verification reads its inputs only through verify_features!; alternative-proof: test:integration
@e2e-exempt
Scenario: verify_features requires an explicit Then step
  When I verify the fixture feature "missing_then.feature" with the fixture steps "steps.exs"
  Then verification fails with a message containing "requires an explicit Then"

# Exemption(e2e): verification reads its inputs only through verify_features!; alternative-proof: test:integration
@e2e-exempt
Scenario: verify_features rejects a step that two bindings match
  When I verify the fixture feature "valid.feature" with the fixture steps "ambiguous_steps.exs"
  Then verification fails with a message containing "matches 2 bindings"

# Exemption(e2e): verification reads its inputs only through verify_features!; alternative-proof: test:integration
@e2e-exempt
Scenario: verify_features rejects a binding that no scenario uses
  When I verify the fixture feature "valid.feature" with the fixture steps "unused_steps.exs"
  Then verification fails with a message containing "is not used"
