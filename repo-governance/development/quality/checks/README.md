---
description: >-
  Indexes the repository check standards: how every rule is enforced, which gate runs each check, how strict lint and
  Markdown checks are, how validators are built, and what a new check needs before it is added.
when_to_use: >-
  Use when adding, placing, or tightening an automated check, or deciding whether a validation belongs to a
  deterministic check or a judgement review.
---

# Checks and Gates Standards

Check and gate standards. They answer which automated check runs where, how strict it is, and how it earns its place.

## Directory Map

- [Automated Quality Gates](automated-quality-gates.md) — Assigns each kind of automated quality check to its gate
  surface: staged-file formatting before a commit, the message at commit time, the leak scan before a push, every other
  check in the pull-request gate, and end-to-end on main.
- [Lint Strictness](lint-strictness.md) — failing at warning severity, cleaning a backlog before a gate goes live,
  documented waivers, and reviewed autofixes
- [Software Quality Enforcement](software-quality-enforcement.md) — Gives every quality rule a declared enforcement
  class and route, forbids making a check pass by weakening it, and never reads a check that inspected nothing, or never
  ran, as a pass.
- [Test and Gate Contract](test-and-gate-contract.md) — Sets the tool-neutral contract every repository's tests and
  gates meet, rules C1 to C24: one gate declaration, one kind of work per surface, a parallel pull-request gate,
  standard test levels and targets, a bound behaviour corpus, a 99% unit floor, and a per-project conformance record.
- [Test and Gate Contract Modules](test-and-gate-contract/README.md) — the modules on Registry and Dispatch, Surface
  Placement, Pull-Request Scope, Test Levels and Targets, Behaviour Corpus, Coverage Floor and Conformance Record
