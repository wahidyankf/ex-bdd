defmodule ExBdd.MixProject do
  use Mix.Project

  @version "0.1.0"
  @description "ExBdd for Elixir: BDD testing framework with Gherkin syntax"

  def project do
    [
      app: :ex_bdd,
      version: @version,
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      description: @description,
      package: package(),
      docs: docs(),
      name: "ExBdd",
      # Ignore ExBdd feature files (not *_test.exs pattern)
      test_ignore_filters: [
        ~r/features\/step_definitions/,
        ~r/features\/support/
      ]
    ]
  end

  def cli do
    [
      preferred_envs: [
        "test.watch": :test,
        precommit: :test,
        "test:quick": :test,
        validate: :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_parsec, "~> 1.4"},
      {:igniter, "~> 0.8.3", optional: true},
      {:ex_doc, "~> 0.40.4", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  # No source_url or repository link yet: this fork is independent of
  # upstream huddlz-hq/cucumber and has no published remote. Add them when
  # the fork gains canonical coordinates; never point them back at upstream.
  defp package do
    [
      maintainers: ["Micah Woods"],
      licenses: ["MIT"],
      links: %{},
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE CHANGELOG.md docs)
    ]
  end

  defp docs do
    [
      main: "getting_started",
      extras: [
        "docs/getting_started.md",
        "docs/feature_files.md",
        "docs/step_definitions.md",
        "docs/hooks.md",
        "docs/attachments.md",
        "docs/error_handling.md",
        "docs/best_practices.md",
        "docs/architecture.md",
        "docs/compatibility.md"
      ],
      groups_for_extras: [
        Guides: Path.wildcard("docs/*.md")
      ]
    ]
  end

  defp aliases do
    [
      precommit: [
        "compile --warnings-as-errors",
        "format",
        "credo --strict",
        "deps.unlock --unused",
        "test"
      ],
      "test:quick": [
        "compile --warnings-as-errors",
        "format --check-formatted",
        "credo --strict",
        "test"
      ],
      validate: [
        "hex.audit",
        "compile --warnings-as-errors",
        "format --check-formatted",
        "credo --strict",
        "deps.unlock --check-unused",
        "test",
        "cmd bash scripts/test_release.sh",
        "cmd env MIX_ENV=dev mix do hex.build + compile --warnings-as-errors + docs --warnings-as-errors"
      ]
    ]
  end
end
