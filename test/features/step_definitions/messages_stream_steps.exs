defmodule MessagesStreamSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions

  step "the Messages builders make a test run started envelope for {string}",
       %{args: [id]} = context do
    Map.put(context, :built, ExBdd.Messages.test_run_started(id, ExBdd.Messages.timestamp(0)))
  end

  step "the built envelope is a testRunStarted envelope for {string}", %{args: [id]} = context do
    assert %{testRunStarted: %{id: ^id}} = context.built
    assert Map.keys(context.built) == [:testRunStarted]
    context
  end
end
