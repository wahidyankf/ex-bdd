# Behaviour Corpus

Plain `.feature` files that state what a user of ExBdd, or a caller of its public API, can observe. Step definitions and
support modules stay under `test/features/`, and Markdown feature fixtures live under `test/fixtures/`.

Each scenario has a unit binding in `test/ex_bdd/` and an integration binding in `test/integration/`. The install and
Markdown discovery scenarios also have an end-to-end binding in `test/e2e/`, where a fresh consumer project runs them.
Every other scenario carries an `@e2e-exempt` tag, and its comment records the reason.
