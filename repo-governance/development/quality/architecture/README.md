---
description: >-
  Indexes the architecture and contract standards: the as-built architecture model, how an application, its domain
  model, its lifecycles, and its decisions are structured, and how an interface others depend on is declared and
  changed.
when_to_use: >-
  Use when structuring an application, its domain model, or a lifecycle; documenting its architecture; or declaring or
  changing an interface that other code or tools depend on.
---

# Architecture and Contracts Standards

Architecture and contract standards. They answer how an application is structured and documented, and how an interface
others rely on is declared and kept compatible.

## Directory Map

- [Functional Core, Imperative Shell](functional-core-imperative-shell.md) — a pure decision core, a thin effect shell,
  and the rules that keep callbacks thin
- [Public Contract](public-contract.md) — a tool's declared surface, and compatible versus breaking changes
- [Consumer Correctness First](consumer-correctness-first.md) — descriptive errors, matching names, and no silent
  behavior on surfaces a consumer touches
- [Hexagonal Architecture Modules](hexagonal-architecture/README.md) — the modules on Layers and the Dependency Rule,
  Ports and Adapters, Composition Roots and Test Adapters and Application Shapes
- [Hexagonal Architecture](hexagonal-architecture.md) — Structures an application as a domain, an application layer that
  owns ports, and adapters at the edge, with every dependency pointing inward and adapters wired in one composition
  root.
