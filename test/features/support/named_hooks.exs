defmodule NamedHooks do
  use ExBdd.Hooks

  before_scenario "@named-hooks", context, name: "set the first named value" do
    {:ok, Map.put(context, :first_named, true)}
  end

  before_scenario "@named-hooks", context, name: "set the second named value" do
    {:ok, Map.put(context, :second_named, true)}
  end
end
