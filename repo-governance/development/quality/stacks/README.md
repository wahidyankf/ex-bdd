---
description: >-
  Indexes the stack standards: the enforced gates, defaults, and design rules one stack adds, each adopted only by
  repositories building with it.
when_to_use: >-
  Use when a repository builds with a stack that has a standard, or when deciding whether a rule belongs to one stack or
  every repository.
---

# Stack Standards

The Elixir standard, for the one stack this repository builds with. It records the normative choices enforced here and
links the language-neutral standards instead of restating them. The repository adapter records the decisions the
standard leaves open. Placement, inheritance, and the selecting inventory follow
[Stack Packs](../../../conventions/structure/stack-packs.md).

## Directory Map

- [Elixir Standards](elixir-standards.md) — warnings-as-errors format, compile, and test gates, strictest-level lint,
  Dialyzer over declared typespecs, tagged-tuple failures, and line-only coverage
- [Repository Adapter](repository-adapter.md) — the adopted pack, the Elixir standard's adopter decisions, and the
  deferred typing and coverage runners
