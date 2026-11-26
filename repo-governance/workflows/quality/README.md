---
name: quality
description: >-
  Indexes the review workflows that judge finished work against criteria stated before the work began, the bounded,
  advisory quality gates with the one propagation that writes for each family, and the red-green-refactor cycle.
when_to_use: >-
  Use when a review is due and you need the procedure that governs it, when a quality gate or its propagation applies,
  or when implementing a behaviour increment test-first.
---

# Quality Workflows

A review compares what exists against what was specified. These workflows exist so that the comparison is made the same
way each time, and so that its result is a verdict rather than an impression.

Every `<family>-quality-gate` follows the [Quality Gate Contract](../../development/workflow/quality-gate-contract.md),
and its `<family>-propagation` sits beside it as the family's sole writer, per
[Sole-Writer Propagation](../../development/workflow/sole-writer-propagation.md). An adopting repository copies or
relinks each gate's companions, and runs its searches, per the contract's
[Adoption](../../development/workflow/quality-gate-contract/004-adoption.md) module.

## Directory Map

- [Docs Propagation](docs-propagation.md)
- [Docs Quality Gate](docs-quality-gate.md)
- [Plan Propagation](plan-propagation.md)
- [Plan Quality Gate](plan-quality-gate.md)
- [PR Leak Review](pr-leak-review.md)
- [PR Leak Review Modules](pr-leak-review/README.md)
- [PR Review](pr-review.md)
- [PR Review Propagation](pr-review-propagation.md)
- [PR Review Quality Gate](pr-review-quality-gate.md)
- [PR Review Quality Gate Modules](pr-review-quality-gate/README.md)
- [Red, Green, Refactor](red-green-refactor.md)
- [Rules Propagation](rules-propagation.md)
- [Rules Propagation Modules](rules-propagation/README.md)
- [Rules Quality Gate](rules-quality-gate.md)
- [API HTTP Propagation](api-http-propagation.md) — Repairs the rows of a frozen api-http-quality ledger in the
  service's source, tests, contract, and specification, each repair landing with a reproducing test; the api-http
  family's sole writer.
- [API HTTP Quality Gate](api-http-quality-gate.md) — Judges a running HTTP interface against its published contract and
  behaviour specifications through real requests in at most three bounded cycles, and returns one advisory verdict.
- [Exploratory and Usability Review](exploratory-usability-review.md) — Runs one bounded exploratory and usability pass
  over declared tasks, recording observations, failures, and a terminal result.
- [Gherkin Implementation Review](gherkin-implementation-review.md) — Compares written Gherkin acceptance scenarios
  against what the implementation and its tests actually do.
- [UI Web Propagation](ui-web-propagation.md) — Repairs the rows of a frozen ui-web-quality ledger in the interface's
  source, tests, and specification, each repair landing with a reproducing test; the ui-web family's sole writer.
- [UI Web Quality Gate](ui-web-quality-gate.md) — Judges a running web user interface against its design, accessibility,
  and behaviour specifications in at most three bounded cycles, and returns one advisory verdict.
