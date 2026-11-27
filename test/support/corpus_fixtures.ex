defmodule ExBdd.CorpusFixtures do
  @moduledoc """
  Sub-runs behind the ExBdd behaviour corpus in `test/features`.

  Some visible behaviours need a failing, pending, raising, or configured run,
  which a green corpus scenario cannot carry on its own. `run/1` runs one small
  fixture through `ExBdd.BehaviorCase` and returns what it observed. The corpus
  step definitions in `test/features/step_definitions/sub_run_steps.exs` assert
  on that result.

  The fixture step and hook modules live here, not under
  `test/features/step_definitions`, so the corpus does not count them as its
  own bindings.
  """

  alias ExBdd.BehaviorCase
  alias ExBdd.BehaviorCase.Collector
  alias ExBdd.Gherkin.Parser

  defmodule Steps do
    @moduledoc false
    use ExBdd.StepDefinition

    step "a step that returns an error", _context do
      {:error, "boom from the error step"}
    end

    step "a step that counts and returns pending", _context do
      Collector.record(:pending_attempt)
      :pending
    end

    step "a step that must not run", _context do
      Collector.record(:step_ran)
      :ok
    end

    step "a step that raises", _context do
      raise "step raised on purpose"
    end

    step "a step that skips the rest of its scenario", _context do
      :skipped
    end

    step "a passing step", _context do
      Collector.record(:passing_step)
      :ok
    end

    step "a step that records a scenario step", _context do
      Collector.record(:scenario_step)
      :ok
    end

    step "an ambiguous step here", _context do
      :ok
    end

    step ~r/^an ambiguous (.*)$/, _context do
      :ok
    end

    step "a step that fails until its third attempt", _context do
      Collector.record(:attempt)

      if Enum.count(Collector.events(), &(&1 == :attempt)) < 3 do
        raise "attempt fails on purpose"
      end

      :ok
    end

    step "a step that attaches a note then fails", context do
      _attached = ExBdd.attach(context, "a note", "text/plain")
      raise "failure after the attachment"
    end
  end

  defmodule PendingOrErrorHooks do
    @moduledoc false
    use ExBdd.Hooks

    before_scenario "@pending-hook", _context do
      :pending
    end

    before_scenario "@error-hook", _context do
      {:error, "hook refused the scenario"}
    end
  end

  defmodule ObserveHooks do
    @moduledoc false
    use ExBdd.Hooks

    after_step "@observe", context do
      Collector.record({:after_step, context.step_status})
      :ok
    end
  end

  defmodule FirstAfterHooks do
    @moduledoc false
    use ExBdd.Hooks

    after_scenario _context do
      Collector.record(:after_first)
      :ok
    end
  end

  defmodule SecondAfterHooks do
    @moduledoc false
    use ExBdd.Hooks

    after_scenario _context do
      Collector.record(:after_second)
      :ok
    end
  end

  defmodule BeforeAllFailHooks do
    @moduledoc false
    use ExBdd.Hooks

    before_all _context, name: "warm-up" do
      {:error, "warm-up failed"}
    end
  end

  defmodule AfterAllFailHooks do
    @moduledoc false
    use ExBdd.Hooks

    after_all _context, name: "first cleanup" do
      Collector.record(:after_all_first)
      :ok
    end

    after_all _context, name: "exploding cleanup" do
      Collector.record(:after_all_exploding)
      raise "cleanup failed on purpose"
    end
  end

  defmodule UnknownTypeSteps do
    @moduledoc false
    use ExBdd.StepDefinition

    step "{airport} is closed because of a strike", _context do
      raise "should not run: the airport parameter type is not defined"
    end
  end

  defmodule SelectionSteps do
    @moduledoc false
    use ExBdd.StepDefinition

    step "a selection step", _context do
      :ok
    end
  end

  @doc """
  Runs the named sub-run fixture and returns what it observed.

  Most results are `ExBdd.BehaviorCase.run_feature/2` maps. `:warning` holds the
  stderr of a fixture that warns, and `:raised` holds the message of a run that
  raises instead of returning.
  """
  @spec run(String.t()) :: map()
  def run(name) do
    do_run(name)
  after
    # A failing run leaves its run-level results (a before_all error, say) in
    # the coordinator; reset it so the corpus scenarios that run later claim
    # their own before_all hooks.
    ExBdd.RunCoordinator.ensure_started()
  end

  defp do_run("a step returns an error") do
    BehaviorCase.run_feature(
      """
      Feature: A step returns an error
        Scenario: the error step
          Given a step that returns an error
      """,
      steps: [Steps]
    )
  end

  defp do_run("a step returns pending") do
    BehaviorCase.run_feature(
      """
      Feature: A step returns pending
        Scenario: the pending step
          Given a step that counts and returns pending
          Then a step that must not run
      """,
      steps: [Steps]
    )
  end

  defp do_run("a missing and an ambiguous step") do
    BehaviorCase.run_feature(
      """
      Feature: Unbound steps
        Scenario: a missing step
          Given a step nobody defines
        Scenario: an ambiguous step
          Given an ambiguous step here
      """,
      steps: [Steps],
      file: "test/fixtures/generated/unbound_steps.feature"
    )
  end

  defp do_run("a before hook returns pending or an error") do
    BehaviorCase.run_feature(
      """
      Feature: Before hooks that return pending or an error
        @pending-hook
        Scenario: the pending hook
          Given a step that must not run

        @error-hook
        Scenario: the error hook
          Given a step that must not run
      """,
      steps: [Steps],
      hooks: [PendingOrErrorHooks]
    )
  end

  defp do_run("a before_all returns an error") do
    sources = [
      """
      Feature: Run-level failure, first
        Scenario: first scenario
          Given a passing step
      """,
      """
      Feature: Run-level failure, second
        Scenario: second scenario
          Given a passing step
      """
    ]

    BehaviorCase.run_features(sources, steps: [Steps], hooks: [BeforeAllFailHooks])
  end

  defp do_run("an after_all raises") do
    BehaviorCase.run_feature(
      """
      Feature: AfterAll failure
        Scenario: the scenario passes
          Given a step that records a scenario step
      """,
      steps: [Steps],
      hooks: [AfterAllFailHooks]
    )
  rescue
    error in RuntimeError ->
      %{raised: Exception.message(error), events: Collector.events()}
  end

  defp do_run("after_step hooks observe outcomes") do
    BehaviorCase.run_feature(
      """
      Feature: After-step outcomes
        @observe
        Scenario: a failing step
          Given a step that raises

        @observe
        Scenario: a pending step
          Given a step that counts and returns pending

        @observe
        Scenario: a skipped step
          Given a step that skips the rest of its scenario
      """,
      steps: [Steps],
      hooks: [ObserveHooks]
    )
  end

  defp do_run("after hooks run in reverse after the steps") do
    BehaviorCase.run_feature(
      """
      Feature: After hook order
        Scenario: the steps run first
          Given a step that records a scenario step
      """,
      steps: [Steps],
      hooks: [FirstAfterHooks, SecondAfterHooks]
    )
  end

  defp do_run("a retry limit set in config") do
    with_app_env(:retry, 2, fn ->
      BehaviorCase.run_feature(
        """
        Feature: Retry limit from config
          Scenario: a flaky scenario with no retry tag
            Given a step that fails until its third attempt
        """,
        steps: [Steps]
      )
    end)
  end

  defp do_run("undefined, ambiguous, and pending scenarios under a retry limit") do
    with_app_env(:retry, 2, fn ->
      BehaviorCase.run_feature(
        """
        Feature: Statuses that never retry
          Scenario: undefined
            Given a step nobody defines

          Scenario: ambiguous
            Given an ambiguous step here

          Scenario: pending
            Given a step that counts and returns pending
        """,
        steps: [Steps]
      )
    end)
  end

  defp do_run("a scenario fails after an attachment") do
    with_messages(fn path ->
      BehaviorCase.run_feature(
        """
        Feature: Attachment on failure
          Scenario: a note, then a failure
            Given a step that attaches a note then fails
        """,
        steps: [Steps],
        messages: path
      )
    end)
  end

  defp do_run("a run with messages") do
    with_messages(fn path ->
      BehaviorCase.run_feature(
        """
        Feature: Messages run
          Scenario: a passing run
            Given a passing step
        """,
        steps: [Steps],
        messages: path
      )
    end)
  end

  defp do_run("a step with an unregistered parameter type") do
    {result, warning} =
      ExUnit.CaptureIO.with_io(:stderr, fn ->
        BehaviorCase.run_feature(
          BehaviorCase.fixture("unknown-parameter-type"),
          steps: [UnknownTypeSteps]
        )
      end)

    Map.put(result, :warning, warning)
  end

  defp do_run("a Markdown feature file") do
    BehaviorCase.run_feature(
      File.read!(ExBdd.MarkdownFixture.path()),
      steps: [ExBdd.MarkdownFixture.Steps],
      file: BehaviorCase.unique_markdown_path()
    )
  end

  defp do_run("a failing step after a passing one") do
    BehaviorCase.run_feature(
      """
      Feature: A failing step after a passing one
        Scenario: the failing step
          Given a passing step
          When a step that raises
      """,
      steps: [Steps]
    )
  end

  defp do_run(name) do
    raise ArgumentError, "no sub-run fixture named #{inspect(name)}"
  end

  @doc """
  Compiles the two selection features: Alpha selection with two scenarios and
  Beta selection with one. Each generated module carries the `ex_bdd` tag and
  its `feature_<name>` tag.
  """
  @spec compile_selection() :: [module()]
  def compile_selection do
    id = System.unique_integer([:positive])
    registry = ExBdd.StepRegistry.new([SelectionSteps], [])

    features =
      for {name, source} <- [{"alpha", alpha_source()}, {"beta", beta_source()}] do
        file = "test/fixtures/generated/selection_#{name}_#{id}.feature"

        source
        |> Parser.parse(file)
        |> Map.put(:file, file)
        |> Map.put(:source, source)
      end

    ExBdd.Compiler.compile_all!(features, registry, [], nil)
  end

  @doc """
  Runs compiled modules with the filters that `mix test --only <tag>` sets.

  Returns the run's counts. `:total` counts every test and `:excluded` the ones
  the filter left out. The previous filters are restored afterwards.
  """
  @spec run_only([module()], String.t()) :: map()
  def run_only(modules, tag) do
    config = ExUnit.configuration()

    try do
      ExUnit.configure(
        include: [{String.to_atom(tag), true}],
        exclude: [:test],
        colors: [enabled: false]
      )

      ExUnit.CaptureIO.capture_io(fn ->
        Process.put(__MODULE__, ExUnit.run(modules))
      end)

      Process.delete(__MODULE__)
    after
      ExUnit.configure(
        include: config[:include],
        exclude: config[:exclude],
        colors: config[:colors]
      )
    end
  end

  defp alpha_source do
    """
    Feature: Alpha selection
      Scenario: first alpha
        Given a selection step
      Scenario: second alpha
        Given a selection step
    """
  end

  defp beta_source do
    """
    Feature: Beta selection
      Scenario: the beta scenario
        Given a selection step
    """
  end

  defp with_app_env(key, value, fun) do
    Application.put_env(:ex_bdd, key, value)

    try do
      fun.()
    after
      Application.delete_env(:ex_bdd, key)
    end
  end

  defp with_messages(fun) do
    path =
      Path.join(System.tmp_dir!(), "corpus-messages-#{System.unique_integer([:positive])}.ndjson")

    try do
      fun.(path)
    after
      File.rm(path)
    end
  end
end
