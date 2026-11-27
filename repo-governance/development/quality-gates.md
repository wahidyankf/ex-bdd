---
description: >-
   Records how this repository meets the test and gate contract: its surfaces, standard targets, and the status of every
  module and rule C1 to C24.
when_to_use: >-
   Use when changing a gate or a test target, setting the coverage floor, or checking which contract rule is open here
  and why.
---

# Quality Gates

The gates follow the [Test and Gate Contract](quality/checks/test-and-gate-contract.md). `repo-config.yml` declares
every gate under `gates.entries`. `./rhino gate list` prints the placement it dispatches; hooks and workflows call
`./rhino gate run --surface <surface>` inside one `./hippo run` boundary.

## Surfaces

Rule C6 sets the placement below. The registry and workflow follow it; C6 stays open because `main` repeats pull-request
checks.

- `pre-commit`: staged-file formatting only.
- `commit-msg`: the commit-message format lint.
- `pre-push`: the leak scan over the pushed range only.
- `pull-request`: every other check, replaying the hook checks, as parallel jobs under one `quality-gate` aggregate.
- `main`: after a push to `main`; it repeats most pull-request checks and is the only place `test:e2e` runs.
- `scheduled`: no gates, no workflow.

## Targets

The standard names are `test:quick`, `test:integration`, `test:e2e`, and `test:behaviour:coverage`. This repository
defines all four. `test:integration` runs on the pull request and `main` through `mix-test-integration`. `test:e2e` runs
on `main` only; its end-to-end test, `consumer_project_test.exs`, builds a fresh consumer project.

## The Test and Gate Contract

Module status, as [Conformance Record](quality/checks/test-and-gate-contract/007-conformance-record.md) requires:

- **001 Registry and Dispatch: adapted, open.** C1 holds. C2 to C5 are open.
- **002 Surface Placement: adapted, open.** C6, C8, and C10 are open. C9 is not applicable, because delivery runs
  through remote pull requests. C11 holds.
- **003 Pull-Request Scope: adopted.** One Elixir project, so every check runs at global scope, which C7 always allows.
- **004 Test Levels and Targets: adapted, open.** C14 and C21 hold. C18 is open.
- **005 Behaviour Corpus: adopted.** C13 holds.
- **006 Coverage Floor: adopted.** C15 holds: `mix test --cover` enforces the 99% floor in `mix.exs`.
- **007 Conformance Record: adopted.** C16, C19, C20, C22, C23, and C24 hold.

| Rule | Status         | Reason                                                                  |
| ---- | -------------- | ----------------------------------------------------------------------- |
| C1   | adopted        | `repo-config.yml` is the one registry, dispatched by `gate run`         |
| C2   | open           | `gates.wiring` is declared; `gate wiring validate` passes               |
| C3   | open           | `npm ci` installs the hooks; no check fails when they are missing       |
| C4   | open           | RHINO and HIPPO are pinned; hosted actions pin full commit SHAs         |
| C5   | open           | no network-denied run is recorded as evidence                           |
| C6   | open           | `main` holds pull-request checks; the hooks hold only their own         |
| C7   | adopted        | one project, so every check runs at global scope                        |
| C8   | open           | parallel pull-request jobs under one `quality-gate` aggregate           |
| C9   | not applicable | delivery is remote-backed pull requests (C20)                           |
| C10  | open           | `commit-msg` and `pull-request` run the commit-message lint             |
| C11  | adopted        | `public-safety-range` runs at `pre-push` and in the pull request        |
| C12  | adopted        | unit and behaviour in `mix test`; integration in `mix-test-integration` |
| C13  | adopted        | the corpus is `specs/behaviours`; `behaviour-coverage` binds it         |
| C14  | adopted        | four standard targets are defined                                       |
| C15  | adopted        | `mix test --cover` enforces the 99% unit floor                          |
| C16  | adopted        | `mix credo --strict` and warnings-as-errors compile run                 |
| C17  | adopted        | unit tests run on the pull request through `mix-test`                   |
| C18  | open           | no unconditional skip or focus ban is declared                          |
| C19  | adopted        | the `README.md` Gates table lists every registry entry                  |
| C20  | adopted        | worktree, pull request, squash merge, and cleanup (`AGENTS.md`)         |
| C21  | adopted        | EX9100 bans clock, file, network, environment, and process calls        |
| C22  | adopted        | the `main` ruleset requires `quality-gate` and blocks force pushes      |
| C23  | adopted        | the `mermaid` validator runs on the pull request and `main`             |
| C24  | adopted        | one product project; no practice code is declared                       |

## Ruleset

The `main` ruleset (GitHub id 26107648) is active: it requires `quality-gate`, blocks force pushes and branch deletion,
and requires linear history. Read back on 2026-11-27, so C22 holds.
