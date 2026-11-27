defmodule AsyncExampleSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions

  step "an async step", context do
    Map.put(context, :first_step, true)
  end

  step "async work happens", context do
    Map.put(context, :async_work_happened, true)
  end

  step "async work should complete", context do
    assert context[:first_step]
    assert context[:async_work_happened]
    context
  end

  step "another async step", context do
    Map.put(context, :second_step, true)
  end

  step "more async work happens", context do
    Map.put(context, :more_async_work_happened, true)
  end

  step "all async work should complete", context do
    assert context[:second_step]
    assert context[:more_async_work_happened]
    context
  end
end
