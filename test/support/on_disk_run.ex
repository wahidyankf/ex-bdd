defmodule ExBdd.OnDiskRun do
  @moduledoc """
  Runs a feature and its step module from real files.

  `run/3` writes one feature file, one step module, and an optional support
  module into a temporary directory, compiles them through
  `ExBdd.compile_features!/1`, runs them with `ExBdd.BehaviorCase.run_isolated/1`, and returns the run
  result with the events its steps recorded. Integration tests use it to prove behaviour
  through the same discovery and compilation path a project takes.
  """

  alias ExBdd.BehaviorCase
  alias ExBdd.BehaviorCase.Collector

  @doc "Returns `{result, events}` for the feature, step, and optional support text."
  def run(feature_text, steps_text, support_text \\ nil) do
    dir = Path.join(System.tmp_dir!(), "ex_bdd_on_disk_#{System.unique_integer([:positive])}")
    File.mkdir_p!(dir)
    feature = Path.join(dir, "on_disk.feature")
    steps = Path.join(dir, "on_disk_steps.exs")
    support = Path.join(dir, "on_disk_support.exs")
    File.write!(feature, feature_text)
    File.write!(steps, steps_text)

    support_files =
      if support_text do
        File.write!(support, support_text)
        [support]
      else
        []
      end

    try do
      ExBdd.RunCoordinator.ensure_started()
      Collector.reset()

      modules =
        ExBdd.compile_features!(features: [feature], steps: [steps], support: support_files)

      {result, _output} = BehaviorCase.run_isolated(modules)
      {result, Collector.events()}
    after
      File.rm_rf(dir)
    end
  end
end
