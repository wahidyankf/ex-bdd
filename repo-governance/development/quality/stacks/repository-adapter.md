---
description: >-
  Records the stack pack ex-bdd adopted, the decisions the Elixir standard leaves open, and every deviation from the
  catalog's testing layers.
when_to_use: >-
  Use when working on the ex_bdd library, adopting or retiring a stack pack, or changing a recorded stack decision.
---

# Repository Adapter

ex-bdd holds one project, the `ex_bdd` library, so [`repo-config.yml`](../../../../repo-config.yml) declares no
`extensions.software-development` inventory; Project Applicability below names the project instead.

## Adopted Packs

| Pack     | Status  | Reason                                             |
| -------- | ------- | -------------------------------------------------- |
| `elixir` | adopted | the library is written for Elixir 1.20.4 on OTP 29 |

## Adopter Decisions

- **`elixir-standards.md`** — Decision: boundary validation; Choice: parse once into structs at the entry point; Reason:
  feature files, CCK fixtures, and Messages payloads enter through the Gherkin parser and the Messages recorder, and
  nothing downstream re-parses raw text
- **`elixir-standards.md`** — Decision: expected failures; Choice: tagged tuples from step definitions and raised step
  errors from the runtime; Reason: `{:error, reason}`, `:pending`, and `:skipped` are the documented step contract,
  while `Cucumber.StepError` and its siblings carry runtime failures
- **`elixir-standards.md`** — Decision: success typing; Choice: Dialyzer deferred; Reason: 21 library files already
  declare `@spec`, but no Dialyzer runner is wired yet, so specs are contracts awaiting evidence, not evidence
- **`elixir-standards.md`** — Decision: coverage floor; Choice: none yet; Reason: no cover tool is wired, so `mix test`
  passing is the only suite evidence

Behaviour-driven development is adopted: the `test/ex_bdd/behavior/` suite and the pinned Cucumber Compatibility Kit
corpus are a behaviour layer above the unit suite, both run by `mix test` under
[Test-Driven Development](../testing/test-driven-development.md). The load gate runs plain `mix test`, not the
standard's `--warnings-as-errors` form: the suite intentionally emits a zero-scenario warning that a test asserts, so
the stricter form cannot pass by design.

## Project Applicability

- `ex_bdd`: the library and its suites; its commands are in the root [README](../../../../README.md).

## Version Sources

- `elixir` and `erlang`: `mise.toml` pins 1.20.4-otp-29 and 29.1.2; `mix.exs` declares the `~> 1.18` floor.
