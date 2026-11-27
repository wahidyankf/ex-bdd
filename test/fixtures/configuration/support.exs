defmodule ExBdd.ConfigurationFixture.Hooks do
  use ExBdd.Hooks

  before_scenario "@configured", context do
    {:ok, Map.put(context, :configured, true)}
  end
end
