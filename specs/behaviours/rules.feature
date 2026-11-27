Feature: Rules group related scenarios
  Rules express a business rule with its own examples.

  Background:
    Given a ledger entry for "feature setup"

  Rule: Totals accumulate ledger entries
    Rule backgrounds run after the feature background.

    Background:
      Given a ledger entry for "rule setup"

    # Behaviour: BH-22
    # Behaviour: BH-25
    # Exemption(e2e): Rule grouping reaches a run only through the Gherkin parser; alternative-proof: test:integration
    @e2e-exempt
    Example: both backgrounds apply
      When I total the ledger
      Then the ledger total is 2

  Rule: Rules can use the Scenario keyword too
    # Behaviour: BH-23
    # Exemption(e2e): Rule grouping reaches a run only through the Gherkin parser; alternative-proof: test:integration
    @e2e-exempt
    Scenario: only the feature background applies
      When I total the ledger
      Then the ledger total is 1

  @rule-tagged
  Rule: Rule tags apply to the scenarios in the rule
    # Behaviour: BH-24
    # Exemption(e2e): Rule grouping reaches a run only through the Gherkin parser; alternative-proof: test:integration
    @e2e-exempt
    Scenario: a scenario inherits the rule tag
      When I total the ledger
      Then the rule tag hook has run
