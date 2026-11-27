Feature: Advanced Gherkin features

Background:
  Given a setup with data table
    | key   | value |
    | setup | true  |

# Exemption(e2e): docstrings and tables reach a step only through the step API; alternative-proof: test:integration
@e2e-exempt
Scenario: Use docstring in a step
  Given a document with text
    """
    This is a multi-line
    docstring that preserves
    formatting and indentation.
    """
  When I process the document
  Then I should verify it contains "multi-line"

# Exemption(e2e): docstrings and tables reach a step only through the step API; alternative-proof: test:integration
@e2e-exempt
Scenario: Use data table in a step
  Given a table of users
    | username | email            | role  |
    | alice    | alice@email.com  | admin |
    | bob      | bob@email.com    | user  |
    | carol    | carol@email.com  | user  |
  When I search for "alice"
  Then I should find user with email "alice@email.com"

# Exemption(e2e): docstrings and tables reach a step only through the step API; alternative-proof: test:integration
@e2e-exempt
Scenario Outline: Placeholders fill a docstring and a data table
  Given I write the greeting:
    """
    Hello <name>, welcome to <place>.
    """
  And the guests are:
    | guest  | city    |
    | <name> | <place> |
  Then the greeting is "Hello <name>, welcome to <place>."
  And the first guest is "<name>" in "<place>"

  Examples:
    | name  | place |
    | Alice | Paris |

# Exemption(e2e): docstrings and tables reach a step only through the step API; alternative-proof: test:integration
@e2e-exempt
Scenario: A blank table cell arrives as an empty string
  Given a guest list with a blank nickname:
    | name  | nickname |
    | alice |          |
  Then the first nickname is ""

# Exemption(e2e): docstrings and tables reach a step only through the step API; alternative-proof: test:integration
@e2e-exempt
Scenario: Escaped pipes and newlines in table cells
  Given a table with escaped cells:
    | text         |
    | a \| b       |
    | line1\nline2 |
  Then the escaped cells are read
