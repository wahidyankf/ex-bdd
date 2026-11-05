# Markdown Visualizations

Use a visualization in Markdown when it makes relationships, sequence, state, hierarchy, dependencies, or another
nontrivial structure materially easier to understand. Appropriate diagrams are encouraged because they can make dense
documentation faster to read.

## Requirements

- Prefer a Mermaid diagram over ASCII art whenever Mermaid can express the needed visualization.
- Choose the smallest diagram type that communicates the point clearly, such as a flowchart, sequence diagram, state
  diagram, class diagram, timeline, or dependency graph.
- Place the diagram near the prose it supports and give nodes, edges, actors, and states meaningful labels.
- Precede each diagram with one sentence that states what it shows. That sentence carries the meaning for a screen
  reader, and for anyone searching the text.
- Keep Mermaid source readable and compatible with the Markdown renderer used by the repository.
- Update a diagram in the same change when the documented behaviour or structure it represents changes.

## Mermaid Accessibility

Every Mermaid diagram carries an accessible title and description, and remains understandable to color-blind readers in
both light and dark rendering modes.

- Carry `accTitle` and `accDescr` on every diagram, describing the nodes and how they connect.
- Never encode meaning through color alone. Combine color with clear labels and, when distinctions matter, different
  shapes, line styles, icons, or symbols.
- Use blue `#0173B2`, orange `#DE8F05`, teal `#029E73`, or brown `#CA9161` for fills; black `#000000` for borders; and
  black or white `#FFFFFF` for text.
- Do not use red, green, yellow, bright magenta, or light red/pink as diagram colors, including for success, failure, or
  warning semantics.
- Define colors with `classDef` and hex values rather than CSS color names or scattered inline styles. Use black borders
  for shape definition, white text on dark fills, and black text on light fills.
- Meet WCAG AA contrast ratios: at least 4.5:1 for normal text and 3:1 for large text.
- Do not annotate the palette in a `%%` Mermaid comment; some editors fail to render a diagram whose first line is a
  comment. State color meaning in the surrounding prose when it needs explanation.
- When adding or materially changing a colored diagram, render it in light and dark modes, check its contrast, and
  review it with at least one color-blindness simulation before publication.

RHINO checks `flowchart`, `graph`, `stateDiagram-v2`, and `erDiagram` diagrams. A checked diagram must declare a
complete `classDef default` where the renderer applies one, carry `accTitle` and `accDescr`, take every fill colour from
the palette, and keep text contrast at 4.5:1 or better. Other Mermaid types pass through unchecked; prefer a checked
type whenever one expresses the visualization.

## Mermaid Legibility

Keep every visible node or state label segment at 32 Unicode grapheme clusters or fewer and every edge or transition
label segment at 24 or fewer. Use `<br>`, `<br/>`, or an escaped newline to split a longer label into independently
measured segments. RHINO strips markup, normalizes whitespace, and counts user-perceived graphemes rather than code
points.

The deterministic check excludes class members, ER attributes, requirement body fields, directives, comments, and front
matter. Its structured finding reports the file, line, label role, measured length, and limit. These limits prevent
known clipping without requiring a browser or renderer; authors must still inspect overall layout when a diagram is
materially changed.

## Focused Validation

For local changed-diagram checks, use `./rhino md mermaid validate --file` once per changed repository-relative Markdown
file. It validates only selected files; the registered gates remain full-surface. The command is pinned to the release
[`rhino.lock`](../../rhino.lock) names.

Directory trees are not diagrams; they stay in `text` or plain blocks in their usual form.

Use prose for a simple fact and a table for compact exact mappings. Do not add a diagram merely as decoration or
duplicate information that is already clearer in another form. ASCII art may be used when Mermaid cannot represent the
information adequately, the target renderer does not support Mermaid, or a plain-text fallback is specifically required.

This convention follows [minimal sufficiency](../principles/minimal-sufficiency.md).

## Enforcement

`policies.markdown.mermaid.authoring-rule: rendered` in [`repo-config.yml`](../../repo-config.yml) makes the `mermaid`
gate check every Mermaid block. Whether a drawing is clear is a judgement for review.
