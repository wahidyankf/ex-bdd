# Test support

Coverage exclusion: test support code is harness code, not shipped behaviour; the tests that use it still run, and they
still assert behaviour.

- Category: test support (`test/support/**`). The modules are fixtures, corpus helpers, and the CCK approval harness
  that only the test suite compiles.
- Declared in `mix.exs` under `test_coverage`, `ignore_modules`, as one namespace regex per support family:
  `ExBdd.BehaviorCase`, `ExBdd.CckApproval`, `ExBdd.CckFixtures`, `ExBdd.CckSchema`, `ExBdd.CckStream`,
  `ExBdd.CorpusFixtures`, and `ExBdd.ReloadableHooks`.
- Still measured: every `lib/` module, and every test file under `test/`. Nothing in `lib/` depends on a support module,
  so no shipped behaviour sits in this category.
- Adding a module to `test/support/` does not exclude it by itself. A support module that ships behaviour the library
  needs must move to `lib/` and stay measured.
