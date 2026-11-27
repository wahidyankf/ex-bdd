---
description: >-
  Indexes the structure conventions: how files, directories, and multi-document sets are shaped and named, how
  governance and plans are organized, and how repositories relate.
when_to_use: >-
  Use when naming a file, laying out a directory or repository, splitting a document, or shaping a plan.
---

# Structure Conventions

Structure conventions answer where something goes and what it is called, so a reader, human or agent, can predict a path
before opening it and a validator can check that prediction mechanically.

- **[Artifact Metadata](artifact-metadata.md)**: frontmatter every governed artifact family carries
- **[File Naming](file-naming.md)**: naming files and directories, and splitting a document
- **[Repository Configuration](repository-configuration.md)**: what a repository is and what must pass before a change
  lands
- **[Plans](plans.md)**: the plan system: lifecycle, documents, delivery, archival
- **[Directory Indexes](directory-indexes.md)**: the README index of every indexed directory
- **[Document Word Budget](document-word-budget.md)**: the instruction and governance document word ceiling, and repair
- **[Governance Layers](governance-layers.md)**: what each governance level answers and which wins a conflict
- **[Stack Packs](stack-packs.md)**: stack standard and skill paths, stack IDs, the inventory, and the repository
  adapter
- **[Temporary Files](temporary-files.md)**: where scratch files and reports go, and their naming and writing

## Directory Map

- [Artifact Metadata](artifact-metadata.md)
- [Artifact Metadata Modules](artifact-metadata/README.md) — schemas by path, shared value rules, portable tiers and
  capabilities
- [File Naming](file-naming.md)
- [File Naming Modules](file-naming/README.md) — portable characters, dated and numbered names, and source filenames
- [Repository Configuration](repository-configuration.md)
- [Repository Configuration Modules](repository-configuration/README.md) — top-level schema, gate entries, surfaces and
  mutation, governance categories
- [Plans Convention](plans.md)
- [Plans Convention Modules](plans/README.md) — the modules, from lifecycle and required documents to the bug-fix plan
- [Directory Indexes](directory-indexes.md)
- [Documentation Architecture](documentation-architecture.md)
- [Document Word Budget](document-word-budget.md)
- [Governance Layers](governance-layers.md)
- [Stack Packs](stack-packs.md)
- [Stack Packs Modules](stack-packs/README.md) — the repository adapter template and inventory extension
- [Temporary Files](temporary-files.md)
- [Monorepo Layout](monorepo-layout.md) — Fixes the dependency direction inside a monorepo, where applications consume
  libraries and libraries form no cycle, and keeps each project's code, tests, and imports within its own boundary.
- [Plan Migrations Modules](plan-migrations/README.md) — the modules on Source Inventory and Contracts
- [Plan Specification Changes](plan-specification-changes.md) — Requires a plan that changes behaviour, interfaces, or
  architecture to state its specification delta file by file, keeping proposed design apart from as-built
  specifications.
- [Plan Validator Contract Modules](plan-validator-contract/README.md) — the modules on Exclusions
- [Project READMEs](project-readmes.md) — Requires a README at the root of every application and library project, fixes
  what it covers, and keeps interface detail in the specification it links to.
- [Specification Tree](specification-tree.md) — Fixes one specification corpus per logical owner, each holding an index,
  an as-built architecture document, and a tree of behaviour specifications, executable features in the fully specified
  case.
