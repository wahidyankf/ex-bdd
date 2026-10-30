# ex-bdd

ex-bdd is an Elixir behaviour-driven development testing framework that runs Gherkin and Markdown feature files as
ExUnit tests and emits the Cucumber Messages stream. See [README.md](README.md). It is one of eight `ose-projects`
repositories, a navigation label only; see [related repositories](docs/README.md#project-context).

For English writing, including replies, use clear, simple, and natural English that is easy for non-native speakers to
understand. Follow [Writing Style](repo-governance/conventions/writing-style.md).

## Consumption

Releases ship the `ex_bdd` Hex package built from `mix.exs`; a released version never moves, per
[Release Cut](repo-governance/workflows/maintenance/release-cut.md). The package manifest (`files`, `licenses`, `links`)
and the HexDocs extras stay true to what `mix hex.build` produces.

## Library

`lib/ex_bdd/` holds the runtime (`runtime.ex`, `run_coordinator.ex`, `test_case.ex`), the compiler (`compiler.ex`,
`discovery.ex`, `step_registry.ex`), the Gherkin front end (`gherkin/`, `expression.ex`, `parameter_types.ex`), hooks,
attachments, and the Messages stream (`messages/`). Step definitions return `:ok`, a map, `{:ok, map}`,
`{:error, reason}`, `:pending`, or `:skipped`; the runtime resolves each step through the registry and shares one test
case between the run and the Messages emitter. `lib/mix/tasks/` holds the installer.

## Gates

```text
mix compile --warnings-as-errors
mix format --check-formatted
mix credo --strict
mix test
npx --no-install prettier --check .
bash scripts/check-package.sh       # the tarball lists the files mix.exs declares
./rhino gate run --surface main     # everything before a pull request
```

`repo-config.yml` is the one gate registry. The husky hooks, the hosted `quality` workflow, and the aggregate command
dispatch it through `./rhino gate run --surface <surface>`, so a gate added there reaches every surface it declares.
`pre-push` refuses a push whose compile, format, credo, or tests fail, and one that breaks a link, a word budget, the
120-column limit, Prettier formatting, or a generated adapter.

`./rhino` installs the RHINO release `rhino.lock` pins and verifies it before running; exit `125` is the wrapper
refusing. This repository pins RHINO and HIPPO: no FERRET. `./hippo` guards local runs under the shared reservation.

## Testing

Work test-first under [Test-Driven Development](repo-governance/development/quality/testing/test-driven-development.md).
The suite runs unit, behaviour (`test/ex_bdd/behavior/`), and pinned Compatibility Kit corpus layers through `mix test`.
Dialyzer and coverage runners stay deferred, per the
[repository adapter](repo-governance/development/quality/stacks/repository-adapter.md).

## Tooling

mise pins Elixir and OTP (`mise.toml`); `mix deps.get` installs the Hex dependencies. `mix precommit` runs format,
credo, and tests before committing. Node carries repository tooling only — Prettier, markdownlint-cli2, and husky, as
`devDependencies` of a private `package.json` — and is never part of the library or its Hex dependencies. `npm ci`
installs it and the hooks.

## Delivery

Every change starts in a task worktree at `worktrees/<task>`, never a sibling directory, and lands through a pull
request merged by squash under [Pull Request Merge](repo-governance/development/workflow/pull-request-merge.md), once
the `quality` check passes on its head. The [PR Leak Review](repo-governance/workflows/quality/pr-leak-review.md)
harness refuses any push or merge without a fresh `leak-reviewer` pass on that head. Everything pushed is public, so
commits, branch names, and pull-request text pass the `scripts/public-safety/` screen first. After the merge,
[Dev Artifact Clean-Up](repo-governance/workflows/maintenance/dev-artifact-clean-up.md) removes the worktree and task
branch and fast-forwards `main`. Never use a co-author trailer in a commit message.

## Documents

- Every Markdown line is at most 120 columns, and every diagram is ASCII art in a `text` block, per
  [Markdown Line Length](repo-governance/conventions/markdown-line-length.md) and
  [Markdown Visualizations](repo-governance/conventions/markdown-visualizations.md): no Mermaid, image, or inline HTML.
- `AGENTS.md`, `CLAUDE.md`, and each `repo-governance/**/*.md` and `.agents/**/*.md` file hold 750 words at most.
- Governed documents declare `description` and `when_to_use` front matter, per
  [Artifact Metadata](repo-governance/conventions/structure/artifact-metadata.md).
- Before any rule edit, follow [Rules Propagation](repo-governance/workflows/quality/rules-propagation.md). A later
  catalog change is taken only through [Adopt Artifact](repo-governance/workflows/adoption/adopt-artifact.md).
- Product documentation lives in `docs/`, indexed by [docs/README.md](docs/README.md).

## Governance and Agents

| Path               | Holds                                                                          |
| ------------------ | ------------------------------------------------------------------------------ |
| `repo-governance/` | principles, conventions, development standards, and workflows from `ose-rules` |
| `agents/`          | canonical agent definitions                                                    |
| `.agents/skills/`  | canonical skills, one directory each with a `SKILL.md`                         |

`./rhino harness adapters generate` renders the declared harness adapters from `.agents/` and `repo-config.yml`; never
hand-edit them. Dispatch every create, modify, update, or delete of code or declarative configuration to the fitting
`swe-*` agent, except a harness without subagents or a tool repin, per
[SWE Delegation](repo-governance/development/agents/swe-delegation.md). `pr-review-*` agents run the PR Review gate;
plan and docs agents run their workflows.
