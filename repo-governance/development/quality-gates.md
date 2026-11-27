---
description: >-
   Records how this repository meets the test and gate contract: its surfaces, targets, and each rule's status.
when_to_use: >-
   Use when changing a gate or a target, or checking which contract rule is open and why.
---

# Quality Gates

The gates follow the [Test and Gate Contract](quality/checks/test-and-gate-contract.md). `repo-config.yml` declares
every gate. Hooks and workflows call `./rhino gate run --surface <surface>` inside one `./hippo run` boundary.

## Surfaces

C6 stays open because `main` repeats pull-request checks.

- `pre-commit`: staged-file formatting only.
- `commit-msg`: the commit-message format lint.
- `pre-push`: the leak scan over the pushed range only.
- `pull-request`: every other check, as parallel jobs under one `quality-gate` aggregate.
- `main`: after a push to `main`; it repeats most pull-request checks and is the only place `test:e2e` runs.
- `scheduled`: no gates, no workflow.

## Targets

This repository defines the four standard targets: `test:quick`, `test:integration`, `test:e2e`, and
`test:behaviour:coverage`. `test:quick` ends with `test:behaviour:coverage` and has no typecheck step yet.
`test:integration` runs on the pull request and `main` through `mix-test-integration`; a corpus scenario tagged
`@integration` runs only there. `test:e2e` runs on `main` only; `consumer_project_test.exs` builds a fresh consumer
project.

## The Test and Gate Contract

Module status, as [Conformance Record](quality/checks/test-and-gate-contract/007-conformance-record.md) requires:

- **001 Registry and Dispatch: adapted, open.** C1 holds. C2 to C5 are open.
- **002 Surface Placement: adapted, open.** C6, C8, and C10 are open. C9 is not applicable: delivery runs through remote
  pull requests. C11 holds.
- **003 Pull-Request Scope: adopted.** One Elixir project; every check runs at global scope (C7).
- **004 Test Levels and Targets: adapted, open.** C12, C14, and C18 are open. C21 holds.
- **005 Behaviour Corpus: adopted.** C13 holds.
- **006 Coverage Floor: adopted.** C15 holds: `mix test --cover` enforces the 99% floor in `mix.exs`.
- **007 Conformance Record: adopted.** C16, C19, C20, C22, C23, and C24 hold.

| Rule | Status         | Reason                                                                                       |
| ---- | -------------- | -------------------------------------------------------------------------------------------- |
| C1   | adopted        | `repo-config.yml` is the one registry, dispatched by `gate run`                              |
| C2   | open           | `gates.wiring` is declared; `gate wiring validate` passes                                    |
| C3   | open           | `npm ci` installs the hooks; no check fails when they are missing                            |
| C4   | open           | RHINO and HIPPO are pinned; hosted actions pin full commit SHAs                              |
| C5   | open           | no network-denied run is recorded as evidence                                                |
| C6   | open           | `main` holds pull-request checks; the hooks hold only their own                              |
| C7   | adopted        | one project, so every check runs at global scope                                             |
| C8   | open           | parallel pull-request jobs under one `quality-gate` aggregate                                |
| C9   | not applicable | delivery is remote-backed pull requests (C20)                                                |
| C10  | open           | `commit-msg` and `pull-request` run the commit-message lint                                  |
| C11  | adopted        | `public-safety-range` runs at `pre-push` and in the pull request                             |
| C12  | open           | EX9100 sees direct calls only; unit tests still read fixtures through library code           |
| C13  | adopted        | the corpus is `specs/behaviours`; `behaviour-coverage` binds it                              |
| C14  | open           | four targets exist; `test:quick` has no typecheck step (Dialyzer deferred)                   |
| C15  | adopted        | `mix test --cover` enforces the 99% unit floor                                               |
| C16  | adopted        | `mix credo --strict` and warnings-as-errors compile run                                      |
| C17  | adopted        | unit tests run on the pull request through `mix-test`                                        |
| C18  | open           | no unconditional skip or focus ban is declared                                               |
| C19  | adopted        | the `README.md` Gates table lists every registry entry                                       |
| C20  | adopted        | worktree, pull request, squash merge, and cleanup (`AGENTS.md`)                              |
| C21  | adopted        | EX9100 bans clock, file, network, env, process, sleep, `:rand` calls written in unit files   |
| C22  | adopted        | `quality-gate` required, strict; no force push or deletion; linear history; no bypass actors |
| C23  | adopted        | the `mermaid` validator runs on the pull request and `main`                                  |
| C24  | adopted        | one product project; no practice code is declared                                            |

## Ruleset

The `main` ruleset (GitHub id 26107648) was read back on 2026-11-27. It is active, targets the default branch
(`refs/heads/main`), and has no bypass actors. Its rules: deletion and force pushes blocked; linear history; a
pull-request rule (0 approvals, stale reviews dismissed, review threads resolved, merge, squash, rebase); and a required
`quality-gate` check (strict policy). It was applied after the owner confirmed it. C22 holds.
