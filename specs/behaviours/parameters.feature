Feature: Parameter extraction

# Exemption(e2e): parameter expressions match only through ExBdd.Expression; alternative-proof: test:integration
@e2e-exempt
Scenario: Testing different parameter types
  Given a number 42
  And a decimal 3.14
  When I click "Submit" on the form
  Then I should see "Success" message on the dashboard

# Exemption(e2e): parameter expressions match only through ExBdd.Expression; alternative-proof: test:integration
@e2e-exempt
Scenario: Atom parameter extraction
  Given status is pending
  Then the status should be the atom pending

# Exemption(e2e): parameter expressions match only through ExBdd.Expression; alternative-proof: test:integration
@e2e-exempt
Scenario: Optional text for pluralization
  Given I have 1 cucumber
  And I have 5 cucumbers
  Then the total cucumber count should be 6

# Exemption(e2e): parameter expressions match only through ExBdd.Expression; alternative-proof: test:integration
@e2e-exempt
Scenario: Alternation matching
  Given I am on the home page
  When I click the submit button
  Then I should have interacted

# Exemption(e2e): parameter expressions match only through ExBdd.Expression; alternative-proof: test:integration
@e2e-exempt
Scenario: Optional parameter arrives as nil when absent
  Given the carton holds  eggs
  Then the egg count is nil
  Given the carton holds 6 eggs
  Then the egg count is 6

# Exemption(e2e): parameter expressions match only through ExBdd.Expression; alternative-proof: test:integration
@e2e-exempt
Scenario: Escaped characters in a step pattern match literal step text
  When a literal {brace} and a path/to/file with call()
  Then the literal step has run

# Exemption(e2e): parameter expressions match only through ExBdd.Expression; alternative-proof: test:integration
@e2e-exempt
Scenario: Alternation matches the second word of click/tap
  Given I am on the home page
  When I tap the submit button
  Then I should have interacted

# Exemption(e2e): parameter expressions match only through ExBdd.Expression; alternative-proof: test:integration
@e2e-exempt
Scenario: A custom parameter type without capture groups gets the whole match
  Given seat 12C is reserved
  Then the reserved seat is "12C"

# Exemption(e2e): parameter expressions match only through ExBdd.Expression; alternative-proof: test:integration
@e2e-exempt
Scenario: The expression API returns typed arguments for matching text
  Given the expression "I have {int} items" is compiled
  When the compiled expression matches "I have 42 items"
  Then the match result is "{:match, [42]}"
  When the compiled expression matches "I have no items"
  Then the match result is ":no_match"

  # Exemption(e2e): parameter expressions match only through ExBdd.Expression; alternative-proof: test:integration
  @e2e-exempt
  Scenario: A step with an unregistered parameter type is reported undefined
    When the sub-run "a step with an unregistered parameter type" runs
    Then the sub-run has 1 failure and 0 passed
    And the sub-run output contains "No matching step definition found"
    And the sub-run warning contains "undefined parameter type {airport}"
