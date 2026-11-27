defmodule GlobalHooksSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions

  step "the run-level setup has happened", context do
    assert is_pid(context.global_hooks_counter)
    :ok
  end

  step "the global hooks step counter has counted this scenario's steps", context do
    # The tagged before_step hook ran before the previous step and before
    # this one
    assert Agent.get(context.global_hooks_counter, & &1) >= 2
    :ok
  end

  step "the global before hook has run", context do
    assert context[:global_before_ran] == true
    context
  end
end
