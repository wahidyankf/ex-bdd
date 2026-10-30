---
description: >-
  Lets source filenames follow their language toolchain instead of document kebab-case, with fixed choices for Elixir
  source and test files.
when_to_use: >-
  Use when naming an Elixir source file, or when a document naming rule is proposed for source code.
---

# Source Files

Document names serve readers and links. A source filename also serves a toolchain that derives meaning from it, so a
source file follows its toolchain's naming, and the kebab-case rule governs documents and directories. These are
enforced choices among names a toolchain would accept, not a restatement of its documentation.

## Elixir

A source file is lowercase `snake_case`, mirroring the module path it houses: `ExBdd.Runtime` lives in
`lib/ex_bdd/runtime.ex`, never in a hyphenated name, since a hyphen cannot appear in a module alias. Test files keep the
same stem and end in `_test.exs`, and Mix task files live under `lib/mix/tasks/` with the same convention.

A file that is run but not compiled into the package — a standalone `.exs` script such as a release check — can take a
kebab-case name that matches the repository's other commands. That allowance lasts only while nothing requires the file:
the change that first requires it also renames it to `snake_case`.

The allowance stays narrow because a kebab-case file that later has to be required forces a rename everywhere it is
called, the very churn the naming choice was made to prevent.

## Enforcement

An adopter using this language enforces these in its own pre-commit or CI source-name check.
