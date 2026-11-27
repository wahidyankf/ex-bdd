---
description: >-
  Indexes the Manual Verification Modules: Quality Gate Results, Verification Layers, Exploratory and Usability Review, Interface Alternatives, Evidence Safety and Accessibility, Behaviour Change Verification, Enumerated Coverage and Usability Probes and Completeness.
when_to_use: >-
  Use when locating one module of Manual Verification for a task.
---

# Manual Verification Modules

Modules of [Manual Verification](../manual-verification.md), each holding one part of its rules.

## Directory Map

- [Quality Gate Results](001-quality-gate-results.md) — Requires every quality gate to return one of four terminal
  results against a frozen snapshot, with no polling state and the repair bound the quality gate contract sets.
- [Verification Layers](002-verification-layers.md) — Distinguishes the three verification layers, requires each
  applicable one to be dispositioned separately, and blocks completion on green automation alone.
- [Exploratory and Usability Review](003-exploratory-and-usability.md) — Requires one canonical bounded review for
  exploratory and usability work, recording tasks, observations, failures, and a terminal result.
- [Interface Alternatives](004-interface-alternatives.md) — Requires three low-fidelity interface alternatives spanning
  three device classes, one reasoned selection, and only the selected one advancing.
- [Evidence Safety and Accessibility](005-evidence-safety.md) — Requires evidence to be a stored artifact with named
  provenance, to carry useful text alternatives, and to contain no private or credential material.
- [Behaviour Change Verification](006-behaviour-change-verification.md) — Requires a real-browser check of every changed
  browser-rendered interface and a direct request to every API operation a behaviour change exercises, with a trigger
  table, a browser checklist, and tool-selection rules.
- [Enumerated Coverage](007-enumerated-coverage.md) — Replaces sampling with enumeration in a verification pass through
  forcing functions for shared controls, state round-trips, declared invariants, and styling consistency, with
  equivalents for API operations.
- [Usability Probes and Completeness](008-usability-probes-and-completeness.md) — Completes the enumerated coverage of a
  verification pass with usability probes, a recheck of earlier defect classes and changed areas, and a closing
  completeness critic.
