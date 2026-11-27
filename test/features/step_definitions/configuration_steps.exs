defmodule ConfigurationSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions

  @keys [:features, :steps, :support]

  step "discovery runs with the config features, steps, and support set to fixtures", context do
    Application.put_env(:ex_bdd, :features, ["test/fixtures/verification/valid.feature"])
    Application.put_env(:ex_bdd, :steps, ["test/fixtures/verification/steps.exs"])
    Application.put_env(:ex_bdd, :support, ["test/fixtures/configuration/support.exs"])

    try do
      Map.put(context, :discovered, ExBdd.Discovery.discover())
    after
      Enum.each(@keys, &Application.delete_env(:ex_bdd, &1))
    end
  end

  step "discovery found {int} feature(s) named {string}", %{args: [count, name]} = context do
    features = context.discovered.features
    assert length(features) == count
    assert Enum.all?(features, &(&1.name == name))
    context
  end

  step "discovery loaded the step module {string}", %{args: [module]} = context do
    assert Module.concat([module]) in context.discovered.step_modules
    context
  end

  step "discovery loaded the support module {string}", %{args: [module]} = context do
    assert Module.concat([module]) in context.discovered.hook_modules
    context
  end
end
