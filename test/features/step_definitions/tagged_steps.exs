defmodule TaggedSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions

  step "a simple smoke test", context do
    Map.put(context, :smoke_test, true)
  end

  step "a regression test", context do
    Map.put(context, :regression_test, true)
  end

  step "a test with multiple tags", context do
    Map.put(context, :multi_tagged, true)
  end

  step "an untagged test", context do
    Map.put(context, :untagged_test, true)
  end

  step "the smoke tag hook has run", context do
    assert context[:smoke_hook] == true
    context
  end

  step "the smoke tag hook has not run", context do
    refute Map.has_key?(context, :smoke_hook)
    context
  end

  step "the regression tag hook has run", context do
    assert context[:regression_hook] == true
    context
  end

  step "the regression tag hook has not run", context do
    refute Map.has_key?(context, :regression_hook)
    context
  end
end
