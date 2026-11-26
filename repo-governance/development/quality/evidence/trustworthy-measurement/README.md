---
description: >-
  Indexes the Trustworthy Measurement Modules: The Run Itself, The Path Measured and Probes and Lasting Assertions.
when_to_use: >-
  Use when locating one module of Trustworthy Measurement for a task.
---

# Trustworthy Measurement Modules

Modules of [Trustworthy Measurement](../trustworthy-measurement.md), each holding one part of its rules.

## Directory Map

- [The Run Itself](001-the-run-itself.md) — Requires a measured run to prove it executed, by asserting exit status and
  output rather than duration, and to prove it finished, by writing a terminal exit marker as its last action.
- [The Path Measured](002-the-path-measured.md) — Requires a measurement to come from the integrated execution path, a
  wall-clock remedy to target the critical path, and a remedy written before the timeline was seen to be re-derived from
  it.
- [Probes and Lasting Assertions](003-probes-and-lasting-assertions.md) — Requires a falsifiability probe to change what
  its check compares, a scan to assert where it stopped, an exit code to come from the check rather than its parser, and
  a test assertion to stay true after the change lands.
