---
description: >-
  Indexes the workflow standards that govern how work is bounded, ordered, committed, integrated, deployed, and brought
  to a terminal state, and how a working environment and its toolchain are prepared.
when_to_use: >-
  Use when designing a repeated operation, when committing, integrating, or deploying a change, when preparing an
  environment or toolchain, or when a process has no obvious stopping point.
---

# Workflow Standards

Standards about the shape of work rather than its subject. Version-control, integration, environment, and toolchain
standards sit alongside them.

## Directory Map

- [Bounded Convergence](bounded-convergence.md) — how a repeated operation is bounded and how it ends, with quality
  gates deferred to their own contract
- [Bounded Convergence Modules](bounded-convergence/README.md) — the modules on loop register and ceiling scorecard
- [Checkout Bootstrap](checkout-bootstrap.md) — Requires each new checkout to run the repository's one declared,
  idempotent bootstrap for dependencies and hooks at its own root before any commit, push, or task-runner command, and
  records when the bootstrap reruns.
- [Commit Authorization](commit-authorization.md) — Requires authorization before staging, committing, or pushing, keeps
  it scoped to the named task, and distinguishes ongoing delivery authority from a single action grant.
- [Commit Messages](commit-messages.md) — the Conventional Commits format and type list, and why types never decide
  commit boundaries
- [Dependency Bump Policy](dependency-bump-policy.md) — exact pins, the long-term-support, soak, and waiver paths,
  vulnerability clearance, and the written cutoff
- [Hook Verification](hook-verification.md) — Requires explicit per-operation authorization, or the worktree-to-PR
  pre-authorization, before skipping a commit or push hook, and requires a failing hook to be reproduced and fixed at
  its cause, never muted, weakened, or routed around.
- [Hook Verification Modules](hook-verification/README.md) — the modules on Capacity-Held Hook
- [Integration Path](integration-path.md) — the branch or direct route to the trunk, branch lifespan, one worktree per
  task, reconcile, and cleanup
- [Native-First Toolchain](native-first-toolchain.md) — pinned native toolchain managers, the idempotent health command,
  what repair may change, and when to revisit
- [No Destructive Git Operations](no-destructive-git-operations.md) — approval outside bounded authorized task sync and
  additive equivalents for destructive effects
- [Authorized Task Sync Modules](no-destructive-git-operations/README.md) — owned sync, recovery, reviews, and gates
- [Pull Request Body](pull-request-body.md) — what a body states, the trunk-state claim, and rewriting the body whenever
  the head moves
- [Pull Request Merge](pull-request-merge.md) — the merge preconditions, the recorded landing method, the no-bypass
  rule, draft readiness, and who holds merge authority
- [Quality Gate Contract](quality-gate-contract.md) — the bounded, advisory cycle every quality gate runs: roles,
  inputs, scoring, termination, verdicts, ledger
- [Quality Gate Contract Modules](quality-gate-contract/README.md) — the modules on inputs, sequence, verdicts, and
  ledger
- [Remote Status Polling](remote-status-polling.md) — the spacing of status reads, no streaming watches, trigger
  discipline, and recovery from a rate limit
- [Resource-Aware Development](resource-aware-development.md) — Routes local compute through one checksum-pinned
  admission guard with bounded recovery.
- [Resource-Aware Development Modules](resource-aware-development/README.md) — the modules on External Nx Cache
  Eviction, Unadmitted Tool Runs, Resource Tiers and Remote Dispatch
- [Sole-Writer Propagation](sole-writer-propagation.md) — the one writer per gate family, its eight shared rules, and
  the family file shape
- [Task Runner Target Standards](task-runner-target-standards.md) — Fixes how a workspace task runner's project targets
  are declared: prerequisite chains, caching only deterministic targets, explicit inputs and outputs, canonical names
  without aliases, ordered aggregates, and no placeholders.
- [Thematic Commits](thematic-commits.md) — Requires each commit to carry one coherent purpose together with every file
  that purpose needs, divides a change set into the fewest build-valid commits by intent, and orders dependent commits.
- [Upstream Tool Defects](upstream-tool-defects.md) — handling pinned upstream tool defects
