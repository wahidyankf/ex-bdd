# Integration tests live under test/integration/ and run only with `--include integration`.
ExUnit.configure(exclude: [:integration])

# The repository-owned hermeticity check (Tools.Credo.HermeticUnitTest) is loaded here, so
# its unit tests in test/tools/ call it without reading any file themselves.
Code.require_file(Path.expand("../tools/credo/hermetic_unit_test.ex", __DIR__))

# Start ExUnit
ExUnit.start()

# Compile ExBdd features into tests
ExBdd.compile_features!()
