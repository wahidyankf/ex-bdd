defmodule ExBdd.DiscoveryConfigTest do
  use ExUnit.Case, async: false

  @keys [:features, :steps, :support]

  # @scenario specs/behaviours/configuration.feature: config features, steps, and support set the discovery paths
  test "config features, steps, and support set the discovery paths" do
    Application.put_env(:ex_bdd, :features, ["test/fixtures/verification/valid.feature"])
    Application.put_env(:ex_bdd, :steps, ["test/fixtures/verification/steps.exs"])
    Application.put_env(:ex_bdd, :support, ["test/fixtures/configuration/support.exs"])

    try do
      result = ExBdd.Discovery.discover()

      assert [feature] = result.features
      assert feature.name == "Strict verification"
      assert Module.concat(["ExBdd", "VerificationFixtureSteps"]) in result.step_modules
      assert Module.concat(["ExBdd", "ConfigurationFixture", "Hooks"]) in result.hook_modules
    after
      Enum.each(@keys, &Application.delete_env(:ex_bdd, &1))
    end
  end
end
