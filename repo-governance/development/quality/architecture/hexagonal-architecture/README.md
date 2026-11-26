---
description: >-
  Indexes the Hexagonal Architecture Modules: Layers and the Dependency Rule, Ports and Adapters, Composition Roots and Test Adapters and Application Shapes.
when_to_use: >-
  Use when locating one module of Hexagonal Architecture for a task.
---

# Hexagonal Architecture Modules

Modules of [Hexagonal Architecture](../hexagonal-architecture.md), each holding one part of its rules.

## Directory Map

- [Layers and the Dependency Rule](001-layers-and-dependency-rule.md) — Defines the four hexagonal layers, what each
  holds and must never import, the inward-only dependency rule, and the one place a domain error becomes a transport
  response.
- [Ports and Adapters](002-ports-and-adapters.md) — Fixes port ownership and granularity, what inbound and outbound
  adapters may and may not do, and where mapping between domain and infrastructure representations lives.
- [Composition Roots and Test Adapters](003-composition-and-testing.md) — Requires one composition root per context as
  the only place adapters are built, a separate test composition root, an in-memory adapter for each output port, and
  one contract suite run against every adapter.
- [Application Shapes](004-application-shapes.md) — Applies hexagonal layering to multi-context services, command-line
  tools, and web applications, and records the adopter's choice between hexagonal layering and a functional core for web
  applications.
