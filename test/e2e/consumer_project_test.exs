defmodule ExBdd.E2E.ConsumerProjectTest do
  # End-to-end proof at the consumer boundary. A fresh Mix project under TMPDIR depends on
  # this checkout by path, runs `mix ex_bdd.install`, and runs `mix test` over one plain
  # feature file and one Markdown feature file. Every dependency is a path dependency on the
  # deps directory of this checkout, so the run makes no network request.
  use ExUnit.Case, async: false

  @moduletag :e2e
  @moduletag timeout: 900_000

  @repo Path.expand("../..", __DIR__)

  @plain_feature ~S"""
  Feature: Checkout totals

    Scenario: A basket totals its items
      Given a basket with 2 items
      When I check out
      Then the total is 2
  """

  @markdown_feature ~S"""
  # Feature: Receipts

  ## Scenario: A receipt lists one item

  * Given a basket with 1 items
  * When I check out
  * Then the total is 1

  ## Scenario Outline: A receipt totals each basket

  * Given a basket with <count> items
  * When I check out
  * Then the total is <total>

  ### Examples:

    | count | total |
    | ----- | ----- |
    | 1     | 1     |
    | 3     | 3     |
  """

  # Mix runs no test at all when a project has no *_test.exs file, so the consumer carries one
  # plain ExUnit test beside its feature files. It reads the library's Markdown parser directly.
  @unit_test ~S"""
  defmodule Consumer.MarkdownParserTest do
    use ExUnit.Case, async: true

    test "a Markdown feature parses to its name and scenarios" do
      feature =
        ExBdd.Gherkin.Parser.parse(
          "# Feature: Parsed\n## Scenario: s\n* Given a step\n",
          "parsed.feature.md"
        )

      assert feature.name == "Parsed"
      assert [%{name: "s"}] = feature.scenarios
    end
  end
  """

  @steps ~S"""
  defmodule Consumer.CheckoutSteps do
    use ExBdd.StepDefinition
    import ExUnit.Assertions

    step "a basket with {int} items", %{args: [count]} = context do
      Map.put(context, :items, count)
    end

    step "I check out", context do
      Map.put(context, :total, context.items)
    end

    step "the total is {int}", %{args: [total]} = context do
      assert context.total == total
      context
    end
  end
  """

  setup_all do
    dir = Path.join(System.tmp_dir!(), "ex_bdd_consumer_#{System.unique_integer([:positive])}")
    File.mkdir_p!(dir)
    on_exit(fn -> File.rm_rf!(dir) end)

    write_consumer!(dir)

    install = run_mix(dir, ["ex_bdd.install", "--yes"])
    tests = run_mix(dir, ["test", "--trace", "--seed", "0"])

    %{dir: dir, install: install, tests: tests}
  end

  # @scenario specs/behaviours/install.feature: mix ex_bdd.install wires test_helper.exs and mix.exs
  test "mix ex_bdd.install wires test_helper.exs and mix.exs", %{dir: dir, install: install} do
    {output, status} = install
    assert status == 0, output

    assert File.read!(Path.join(dir, "test/test_helper.exs")) ==
             "ExUnit.start()\nExBdd.compile_features!()\n"

    mix_exs = File.read!(Path.join(dir, "mix.exs"))
    assert mix_exs =~ "~r/features\\/step_definitions/"
    assert mix_exs =~ "~r/features\\/support/"
  end

  # credo:disable-for-next-line Credo.Check.Readability.MaxLineLength
  # @scenario specs/behaviours/markdown_feature_files.feature: feature files written in Markdown are discovered and their scenarios run like plain ones
  test "feature files written in Markdown are discovered and their scenarios run like plain ones",
       %{tests: tests} do
    {output, status} = tests
    assert status == 0, output

    # One plain scenario, one Markdown scenario, two Markdown outline rows, and the plain test.
    assert output =~ "Result: 5 passed"
    assert output =~ "A basket totals its items"
    assert output =~ "A receipt lists one item"
    assert output =~ "A receipt totals each basket (row 1)"
    assert output =~ "A receipt totals each basket (row 2)"
  end

  defp write_consumer!(dir) do
    File.write!(Path.join(dir, "mix.exs"), mix_exs())
    File.mkdir_p!(Path.join(dir, "test/features/step_definitions"))
    File.write!(Path.join(dir, "test/test_helper.exs"), "ExUnit.start()\n")
    File.write!(Path.join(dir, "test/features/checkout.feature"), @plain_feature)
    File.write!(Path.join(dir, "test/features/receipts.feature.md"), @markdown_feature)
    File.write!(Path.join(dir, "test/features/step_definitions/checkout_steps.exs"), @steps)
    File.write!(Path.join(dir, "test/markdown_parser_test.exs"), @unit_test)
  end

  # The consumer depends on this checkout by path, and on every dependency of this checkout
  # by path too, so Mix resolves the whole graph from disk.
  defp mix_exs do
    path_deps =
      for {app, path} <- Mix.Project.deps_paths(), app != :ex_bdd do
        "      {#{inspect(app)}, path: #{inspect(Path.expand(path))}, override: true}"
      end

    """
    defmodule Consumer.MixProject do
      use Mix.Project

      def project do
        [app: :consumer, version: "0.1.0", elixir: "~> 1.18", deps: deps()]
      end

      defp deps do
        [
          {:ex_bdd, path: #{inspect(@repo)}, override: true}#{Enum.map_join(path_deps, "", &(",\n" <> &1))}
        ]
      end
    end
    """
  end

  defp run_mix(dir, args) do
    System.cmd("mix", args,
      cd: dir,
      env: [{"MIX_ENV", "test"}, {"HEX_OFFLINE", "1"}],
      stderr_to_stdout: true
    )
  end
end
