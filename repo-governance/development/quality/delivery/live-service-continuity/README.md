---
description: >-
  Indexes the Live-Service Continuity Modules: Invariants, Release Cutover and Restart Discipline.
when_to_use: >-
  Use when locating one module of Live-Service Continuity for a task.
---

# Live-Service Continuity Modules

Modules of [Live-Service Continuity](../live-service-continuity.md), each holding one part of its rules.

## Directory Map

- [Invariants](001-invariants.md) — Lists the availability, responsiveness, revision, last-good-version, shared-state,
  and cleanup invariants that hold for a live service through every step of a change.
- [Release Cutover](002-release-cutover.md) — Governs promoting a release of a live service: an immutable artifact from
  a disposable worktree, candidates that prove their revision, explicit migrations numbered at use, traffic cutovers
  that drop no connection, and rollback before diagnosis.
- [Restart Discipline](003-restart-discipline.md) — Governs starting or restarting the development server of an
  application users can reach while work continues: reuse the identified existing process, keep it where its owner
  watches it, and restart as soon as its inputs change.
