defmodule SubRunSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions

  step "the sub-run {string} runs", %{args: [name]} = context do
    Map.put(context, :sub_run, ExBdd.CorpusFixtures.run(name))
  end

  step "the sub-run has {int} failure(s) and {int} passed",
       %{args: [failures, passed]} = context do
    assert {context.sub_run.failures, context.sub_run.passed} == {failures, passed}
    context
  end

  step "the sub-run output contains {string}", %{args: [text]} = context do
    assert context.sub_run.output =~ text
    context
  end

  step "the sub-run output does not contain {string}", %{args: [text]} = context do
    refute context.sub_run.output =~ text
    context
  end

  step "the sub-run warning contains {string}", %{args: [text]} = context do
    assert context.sub_run.warning =~ text
    context
  end

  step "the sub-run raised {string}", %{args: [message]} = context do
    assert context.sub_run.raised == message
    context
  end

  step "the sub-run events are {string}", %{args: [expected]} = context do
    assert event_labels(context.sub_run) == String.split(expected, "; ")
    context
  end

  step "the sub-run events include {string}", %{args: [label]} = context do
    assert label in event_labels(context.sub_run)
    context
  end

  step "the sub-run events do not include {string}", %{args: [label]} = context do
    refute label in event_labels(context.sub_run)
    context
  end

  step "the sub-run messages include an envelope {string}", %{args: [type]} = context do
    assert Enum.any?(context.sub_run.messages, &Map.has_key?(&1, type))
    context
  end

  defp event_labels(run), do: Enum.map(run.events, &label/1)

  defp label(event) when is_atom(event), do: Atom.to_string(event)
  defp label(event), do: inspect(event)
end
