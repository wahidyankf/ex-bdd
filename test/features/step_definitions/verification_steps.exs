defmodule VerificationSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions

  @fixtures Path.expand("../../fixtures/verification", __DIR__)

  step "I verify the fixture feature {string} with the fixture steps {string}",
       %{args: [feature, steps]} = context do
    outcome =
      try do
        {:ok,
         ExBdd.verify_features!(
           features: [Path.join(@fixtures, feature)],
           steps: [Path.join(@fixtures, steps)],
           support: []
         )}
      rescue
        error -> {:error, error}
      end

    Map.put(context, :verification, outcome)
  end

  step "the verification counts are {int} feature(s), {int} scenario(s), and {int} step(s)",
       %{args: [features, scenarios, steps]} = context do
    {:ok, result} = context.verification

    assert {result.feature_count, result.scenario_count, result.step_count} ==
             {features, scenarios, steps}

    context
  end

  step "the verification has {int} binding(s)", %{args: [bindings]} = context do
    {:ok, result} = context.verification
    assert result.binding_count == bindings
    context
  end

  step "verification fails with a message containing {string}", %{args: [expected]} = context do
    assert {:error, %ExBdd.VerificationError{} = error} = context.verification
    assert Exception.message(error) =~ expected
    context
  end
end
