---
description: >-
  Indexes the testing standards: which layer and gate a test belongs to, how tests come first, what API, behaviour, and
  end-to-end tests assert, how tests isolate data and fixtures, and which test doubles replace what.
when_to_use: >-
  Use when deciding how a change is tested, which test layer or gate applies, how a test isolates its data and fixtures,
  or which test double replaces a collaborator.
---

# Testing Standards

Testing standards. They answer which test proves a behaviour, where it runs, and what a test may replace or touch.

## Directory Map

- [API Testing](api-testing.md) — Requires an API change to carry automated contract proof at each applicable test layer
  plus a direct request against the exact served origin, recorded as redacted evidence.
- [Behaviour-Driven Development](behaviour-driven-development.md) — Chooses a Gherkin scenario for contract behaviour
  and a plain test for a developer detail, makes one canonical corpus per owner of runtime code the statement of
  caller-visible behaviour, and binds it strictly at every applicable test layer.
- [Behaviour-Driven Development Modules](behaviour-driven-development/README.md) — the modules on Discovery and
  Scenarios, Layers and Adapters, Bindings and Exemptions and Compliance and Reporting
- [End-to-End Testing](end-to-end-testing.md) — Confines end-to-end tests to the public boundary a user or caller meets,
  gives each case its own temporary fixtures, keeps the suite out of fast hooks, and guarantees browser cleanup.
- [Git Fixture Isolation](git-fixture-isolation.md) — Requires every test that creates or changes a throwaway git
  repository to apply six independent isolation layers, so no git command a test runs can reach the enclosing real
  repository.
- [Meaningful Coverage](meaningful-coverage.md) — what numeric coverage may measure, what stays outside it, and native
  verification where no instrument is reliable
- [Meaningful Coverage Modules](meaningful-coverage/README.md) — the modules on Exclusions
- [Test Boundaries and Gates](test-boundaries-and-gates.md) — what each test boundary excludes, separate suites, gates
  composed from named targets, the fast gate, and gating coverage
- [Test Data Isolation](test-data-isolation.md) — Forbids tests from touching production users, data, or credentials,
  and requires synthetic data inside a marked per-run boundary that is validated before use and removed exactly
  afterwards.
- [Test Doubles](test-doubles.md) — in-memory fakes over mocks, stubbed external services, and real domain objects
- [Test-Driven Development](test-driven-development.md) — test-first red, green, and refactor cycles for behaviour
  changes and bug fixes, with scope and exemptions
- [Test-Driven Development Modules](test-driven-development/README.md) — cycle evidence, test design, regression tests,
  and intermittent failures
