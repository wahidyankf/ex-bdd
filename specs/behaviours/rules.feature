Feature: Rules group related scenarios
  Rules express a business rule with its own examples.

  Background:
    Given a ledger entry for "feature setup"

  Rule: Totals accumulate ledger entries
    Rule backgrounds run after the feature background.

    Background:
      Given a ledger entry for "rule setup"

    # Exemption(e2e): Rule grouping reaches a run only through the Gherkin parser; alternative-proof: test:integration
    @e2e-exempt
    Example: both backgrounds apply
      When I total the ledger
      Then the ledger total is 2

  Rule: Rules can use the Scenario keyword too
    # Exemption(e2e): Rule grouping reaches a run only through the Gherkin parser; alternative-proof: test:integration
    @e2e-exempt
    Scenario: only the feature background applies
      When I total the ledger
      Then the ledger total is 1

  @rule-tagged
  Rule: Rule tags apply to the scenarios in the rule
    # Exemption(e2e): Rule grouping reaches a run only through the Gherkin parser; alternative-proof: test:integration
    @e2e-exempt
    Scenario: a scenario inherits the rule tag
      When I total the ledger
      Then the rule tag hook has run
