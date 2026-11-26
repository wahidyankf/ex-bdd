defmodule TagSelectionHooks do
  use ExBdd.Hooks

  before_scenario "@smoke", context do
    {:ok, Map.put(context, :smoke_hook, true)}
  end

  before_scenario "@regression", context do
    {:ok, Map.put(context, :regression_hook, true)}
  end

  before_scenario "@rule-tagged", context do
    {:ok, Map.put(context, :rule_hook, true)}
  end
end
