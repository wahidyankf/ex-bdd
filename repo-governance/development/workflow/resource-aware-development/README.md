---
description: >-
  Indexes the Resource-Aware Development Modules: External Nx Cache Eviction, Unadmitted Tool Runs, Resource Tiers and Remote Dispatch.
when_to_use: >-
  Use when locating one module of Resource-Aware Development for a task.
---

# Resource-Aware Development Modules

Modules of [Resource-Aware Development](../resource-aware-development.md), each holding one part of its rules.

## Directory Map

- [External Nx Cache Eviction](001-external-nx-cache-eviction.md) — Records the bounded consequences of separately
  approved external eviction of a local Nx task cache.
- [Unadmitted Tool Runs](002-unadmitted-tool-runs.md) — Fixes which spellings of `prettier` and `markdownlint-cli2` run
  without admission, and why every other spelling stays guarded.
- [Resource Tiers](003-resource-tiers.md) — Defines the HIPPO resource tiers as reservations: three required tiers and
  one optional last-resort tier, the two failure modes of a wrong tier, and the queue rule that follows from them.
- [Remote Dispatch](004-remote-dispatch.md) — States when an adopter may dispatch compute to another machine it
  controls, the lifecycle each dispatch follows, and the confidentiality rules that already bind it.
