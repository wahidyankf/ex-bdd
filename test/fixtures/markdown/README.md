# Markdown Feature Fixture

`markdown.feature.md` is input data for ExBdd's Markdown feature support. It is not part of the behaviour corpus under
`specs/behaviours/`, so the corpus does not discover it by default. These tests read it:

- `test/ex_bdd/gherkin/markdown_corpus_test.exs` runs it as a sub-run and counts its fixture steps.
- `test/ex_bdd/verification_test.exs` checks that the verifier rejects its Given-only scenario.
- `test/integration/gherkin_test.exs` counts its scenarios and outlines in the corpus check.
- `test/features/step_definitions/markdown_steps.exs` and `test/support/corpus_fixtures.ex` use its path.

The corpus scenario "feature files written in Markdown are discovered and their scenarios run like plain ones" covers
how Markdown feature files are discovered and run.
