Feature: Attachments

Scenario: attach, log, and link return the context unchanged
  Given a context holding a value
  When I attach text, a log line, and a link
  Then the context still holds its value

  Scenario: Attachments show on failure and in the NDJSON stream
    When the sub-run "a scenario fails after an attachment" runs
    Then the sub-run has 1 failure and 0 passed
    And the sub-run output contains "Attachments:"
    And the sub-run output contains "* text/plain: a note"
    And the sub-run messages include an envelope "attachment"
