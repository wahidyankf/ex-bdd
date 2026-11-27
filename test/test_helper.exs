# Integration tests live under test/integration/ and run only with `--include integration`.
# End-to-end tests live under test/e2e/ and run only with `--include e2e`.
ExUnit.configure(exclude: [:integration, :e2e])

# The repository-owned hermeticity check (Tools.Credo.HermeticUnitTest) is loaded here, so
# its unit tests in test/tools/ call it without reading any file themselves.
Code.require_file(Path.expand("../tools/credo/hermetic_unit_test.ex", __DIR__))

# Start ExUnit
ExUnit.start()

# Compile ExBdd features into tests
ExBdd.compile_features!(features: ["specs/behaviours/**/*.feature"])
