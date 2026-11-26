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
every gate under `gates.entries`. `./rhino gate list` prints the placement it dispatches, and hooks and workflows call a
surface with `./rhino gate run --surface <surface>`.

## Surfaces

Rule C6 sets the target placement below. The registry does not match it yet, and each gap is open in the table.

- `pre-commit`: staged-file formatting only.
- `commit-msg`: the commit-message format lint.
- `pre-push`: the leak scan over the pushed range only.
- `pull-request`: every other check, replaying the hook checks, as one job.
- `main` and `scheduled`: `test:e2e` only, once the repository has end-to-end tests.

## Targets

The standard names are `test:quick`, `test:integration`, `test:e2e`, and `test:behaviour:coverage`. This repository
defines the three that exist, and `test:integration` runs only when invoked by hand. It has no end-to-end suite, so
`test:e2e` is undefined.

## The Test and Gate Contract

Module status, as [Conformance Record](quality/checks/test-and-gate-contract/007-conformance-record.md) requires:

- **001 Registry and Dispatch: adapted, open.** C1 holds. C2 to C5 are open.
- **002 Surface Placement: adapted, open.** C6, C8, and C10 are open. C9 is not applicable, because delivery runs
  through remote pull requests. C11 holds.
- **003 Pull-Request Scope: adopted.** One Elixir project, so every check runs at global scope, which C7 always allows.
- **004 Test Levels and Targets: adapted, open.** C14, C18, and C21 are open.
- **005 Behaviour Corpus: adapted, open.** C13 is open: the corpus lives in `test/features`, not `specs/behaviours/`.
- **006 Coverage Floor: adapted, open.** C15 is open: the 99% unit floor is not met, and no cover tool is wired.
- **007 Conformance Record: adapted, open.** C22 is open. C16, C19, C20, C23, and C24 hold.

| Rule | Status         | Reason                                                             |
| ---- | -------------- | ------------------------------------------------------------------ |
| C1   | adopted        | `repo-config.yml` is the one registry, dispatched by `gate run`    |
| C2   | open           | `gates.wiring` is declared; `gate wiring validate` passes          |
| C3   | open           | `npm ci` installs the hooks; no check fails when they are missing  |
| C4   | open           | RHINO and HIPPO are pinned; hosted actions pin full commit SHAs    |
| C5   | open           | no network-denied run is recorded as evidence                      |
| C6   | open           | `main` holds pull-request checks; the hooks hold only their own    |
| C7   | adopted        | one project, so every check runs at global scope                   |
| C8   | open           | parallel pull-request jobs under one `quality-gate` aggregate      |
| C9   | not applicable | delivery is remote-backed pull requests (C20)                      |
| C10  | open           | `commit-msg` and `pull-request` run the commit-message lint        |
| C11  | adopted        | `public-safety-range` runs at `pre-push` and in the pull request   |
| C12  | adopted        | unit and behaviour tests run in `mix test`; integration is ungated |
| C13  | open           | the corpus is `test/features`; the binding check is not wired      |
| C14  | open           | three targets are defined; `test:e2e` is not                       |
| C15  | open           | the 99% unit floor is not met; no cover tool is wired              |
| C16  | adopted        | `mix credo --strict` and warnings-as-errors compile run            |
| C17  | adopted        | unit tests run on the pull request through `mix-test`              |
| C18  | open           | no unconditional skip or focus ban is declared                     |
| C19  | adopted        | the `README.md` Gates table lists every registry entry             |
| C20  | adopted        | worktree, pull request, squash merge, and cleanup (`AGENTS.md`)    |
| C21  | open           | no mechanical ban on clock, file, network, or process use in units |
| C22  | open           | the required check is `quality-gate`; the ruleset is not recorded  |
| C23  | adopted        | the `mermaid` validator runs on the pull request and `main`        |
| C24  | adopted        | one product project; no practice code is declared                  |

## Ruleset

The `main` ruleset that requires the `quality-gate` check (C22) is a target. Applying it changes hosting settings, so
the owner confirms it first.
