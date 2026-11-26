defmodule RulesSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions

  step "a ledger entry for {string}", %{args: [entry]} = context do
    %{ledger: Map.get(context, :ledger, []) ++ [entry]}
  end

  step "I total the ledger", context do
    %{ledger_total: length(context.ledger)}
  end

  step "the ledger total is {int}", %{args: [expected]} = context do
    assert context.ledger_total == expected
    :ok
  end

  step "the rule tag hook has run", context do
    assert context[:rule_hook] == true
    context
  end
end
