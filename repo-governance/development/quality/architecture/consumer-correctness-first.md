---
description: >-
  Chooses the surface that most helps the consumer be correct when options differ: errors that name the cause and the
  fix, names that match across surfaces, and no silent behavior.
when_to_use: >-
  Use when designing or changing any surface a consumer reads or calls — an error message, a name, a default, or a
  behavior — and a shorter option competes with a more explicit one.
---

# Consumer Correctness First

When options differ, choose the one that most helps the end user or consumer be correct. Consumers cannot read
maintainer intent: ambiguity becomes misuse, and misuse becomes incidents. A terse or ambiguous surface that lets misuse
pass quietly is the wrong choice even when it is shorter.

This standard implements [Explicit Over Implicit](../../../principles/explicit-over-implicit.md) and
[Fail Closed](../../../principles/fail-closed.md): the first says behaviour a reader depends on is written down, the
second says a control that cannot decide refuses. This standard applies both to every surface a consumer touches.

## What It Requires

- **Errors name the cause and the fix.** An error states what happened, why it happened, and what the consumer does
  next. An error that only names a symptom sends the consumer searching; one that cannot name the fix says so and points
  at where to look. [Error Handling and Debugging](../../../../docs/error-handling.md) shows the shape: each failure
  names its scenario and location, and a missing step definition prints the step to write.
- **Names match across surfaces.** One concept carries one exact name in code, messages, configuration, output, and
  documentation, so a consumer copying a name from an error finds it in the documentation. A rename updates every
  surface in the same change, since a rename is a contract change per [Public Contract](public-contract.md).
- **No silent behavior.** Misuse fails loudly at the point of error: no guessing, no defaulting, no passing where the
  consumer's intent is unclear. An ambiguous step fails listing every match rather than running the first one, and a
  retried scenario prints its flake warning so quiet flakiness stays visible.

## Enforcement

Review applies what no checker sees: whether an error names its cause and fix, whether a name matches across surfaces,
and whether misuse fails loudly. The disposition is unenforced by decision, because no mechanical check can judge
whether an explanation actually explains; the gates below still run over every surface this standard touches.
