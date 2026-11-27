defmodule SelectionCorpusSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions

  step "two features are compiled for selection", context do
    Map.put(context, :selection_modules, ExBdd.CorpusFixtures.compile_selection())
  end

  step "the selection runs only the tag {string}", %{args: [tag]} = context do
    run = ExBdd.CorpusFixtures.run_only(context.selection_modules, tag)
    Map.put(context, :selection_run, run)
  end

  step "{int} scenario(s) run and {int} excluded", %{args: [ran, excluded]} = context do
    run = context.selection_run
    assert {run.total - run.excluded, run.excluded, run.failures} == {ran, excluded, 0}
    context
  end
end
