# ex-bdd documentation

Start with [Getting Started](getting-started.md): it adds the library to a project and runs a first feature.

## Directory Map

- [Getting Started](getting-started.md) — first feature run
- [Feature Files](feature-files.md) — Gherkin and Markdown feature files
- [Step Definitions](step-definitions.md) — typed step definitions
- [Hooks](hooks.md) — run, scenario, and step hooks
- [Attachments](attachments.md) — screenshots, logs, and payloads
- [Error Handling](error-handling.md) — failure reading and debugging
- [Best Practices](best-practices.md) — fast, isolated, readable suites
- [Architecture](architecture.md) — discovery, compilation, runtime
- [Compatibility](compatibility.md) — Compatibility Kit coverage and boundaries
- [Architecture Decision Records](adr/README.md) — decisions with context and consequences

Each guide below covers one job:

- [Feature Files](feature-files.md) — write executable specifications in Gherkin or Markdown
- [Step Definitions](step-definitions.md) — bind step text to Elixir code with typed parameters
- [Hooks](hooks.md) — run setup and teardown around runs, scenarios, and steps
- [Attachments](attachments.md) — attach screenshots, logs, and payloads to steps
- [Error Handling](error-handling.md) — read failures, from pending steps to undefined ones
- [Best Practices](best-practices.md) — keep suites fast, isolated, and readable
- [Architecture](architecture.md) — how discovery, compilation, and the runtime fit together
- [Compatibility](compatibility.md) — what the Compatibility Kit corpus covers and what it excludes

## Project context

The [README](../README.md) is the short front door, and [CHANGELOG.md](../CHANGELOG.md) records what each version holds.
Contribution rules and the gates live in [AGENTS.md](../AGENTS.md); they govern changing the repository, not using it.

ex-bdd is one of the eight **`ose-projects`** repositories — the repositories
[Open Sharia Enterprise](https://github.com/wahidyankf/ose-public) is built and maintained in. Each entry gives the
repository's role, then how it relates to ex-bdd:

- **[`ex-bdd`](https://github.com/wahidyankf/ex-bdd)** — behaviour-driven development testing for Elixir. This
  repository.
- [`ose-public`](https://github.com/wahidyankf/ose-public) — the OSE product platform and research. None yet: named here
  only because it is a member.
- [`hippo`](https://github.com/wahidyankf/hippo) — host resource coordination. Upstream consumption: ex-bdd's local runs
  are guarded by a pinned HIPPO release.
- [`rhino`](https://github.com/wahidyankf/rhino) — repository hygiene. Upstream consumption: ex-bdd's gates pin a RHINO
  release.
- [`ose-rules`](https://github.com/wahidyankf/ose-rules) — the reference catalog of governance, planning, agent, and
  skill artifacts. Knowledge sharing: ex-bdd adopts its artifacts by explicit one-off copy and owns each copy.
- [`beaver-nest`](https://github.com/wahidyankf/beaver-nest) — an independent family product. History: ex-bdd's first
  release ported BeaverNest's test APIs.
- [`ose-private`](https://github.com/wahidyankf/ose-private) (Private) — authorized operations. None: named only because
  it is a member. Its name and link are public by the maintainer's 2026-10-07 decision; its contents stay private, and
  the link resolves only for authorized maintainers.
- [`py-typekit`](https://github.com/wahidyankf/py-typekit) — typed functional primitives for Python. None: named only
  because it is a member.

**That label is navigation, not coupling.** `ose-projects` is a routing label only — not an organization, a parent
repository, a parity group, or a shared release. The eight are developed, versioned, gated, and released independently.
Membership obliges each member only to name the others, so a reader who finds one can find the other seven, and nothing
more. ex-bdd is usable entirely on its own.
