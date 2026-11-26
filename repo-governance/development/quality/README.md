---
description: >-
  Indexes the quality standards: how work is verified and what counts as evidence that it holds; how code is designed,
  tested, contracted, checked, delivered, and kept accessible; and the rules a language or framework stack adds.
when_to_use: >-
  Use when deciding how a change will be verified, or what a piece of evidence has to contain, or which design, code,
  testing, contract, delivery, accessibility, stack, or repository-check standard applies.
---

# Quality Standards

Verification standards. They answer what proves a change works, and what a proof has to look like to be worth anything
to someone who was not there when it was produced. Code, testing, contract, stack, and check standards sit alongside
them.

## Directory Map

- [Architecture and Contracts](architecture/README.md) — the public contract and its compatible and breaking changes
- [Checks and Gates](checks/README.md) — lint strictness and documented waivers
- [Code](code/README.md) — dependency selection, and type and boundary safety
- [Deletion With Proof](deletion-with-proof.md) — Requires anything being deleted or retired to have an inventory, a
  named successor for each responsibility, and a test that fails without it.
- [Delivery Modules](delivery/README.md) — the modules on Live-Service Continuity Modules and Live-Service Continuity
- [Evidence](evidence/README.md) — finding criticality and confidence ratings
- [Manual Verification](manual-verification.md) — Defines the verification layers automation cannot replace, how each
  one is asserted and evidenced, and when green automation is not sufficient to close work.
- [Manual Verification Modules](manual-verification/README.md) — the modules on Quality Gate Results, Verification
  Layers, Exploratory and Usability Review, Interface Alternatives, Evidence Safety and Accessibility, Behaviour Change
  Verification, Enumerated Coverage and Usability Probes and Completeness
- [Stacks](stacks/README.md) — the Elixir standard and the repository adapter recording its decisions
- [Testing](testing/README.md) — test layers and gates, test-first work, meaningful coverage, and test doubles
