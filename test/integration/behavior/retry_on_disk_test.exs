defmodule ExBdd.Integration.RetryOnDiskTest do
  use ExUnit.Case, async: false
  @moduletag :integration

  alias ExBdd.BehaviorCase
  alias ExBdd.OnDiskRun

  # @scenario specs/behaviours/retry.feature: a flaky scenario eventually passes
  test "a flaky scenario eventually passes on disk" do
    start_supervised!(%{
      id: :flaky_counter,
      start: {Agent, :start_link, [fn -> 0 end, [name: ExBdd.Integration.FlakyCounter]]}
    })

    {result, events} =
      OnDiskRun.run(
        """
        Feature: Flaky on disk
          @retry-2
          Scenario: a flaky scenario
            Given a flaky step
        """,
        ~S"""
        defmodule ExBdd.Integration.FlakySteps do
          use ExBdd.StepDefinition

          step "a flaky step", context do
            attempt = Agent.get_and_update(ExBdd.Integration.FlakyCounter, fn n -> {n + 1, n + 1} end)
            ExBdd.BehaviorCase.Collector.record({:attempt, attempt})
            if attempt < 2, do: raise("flaky on attempt #{attempt}")
            context
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, {:attempt, 2}) == 1
  end

  # @scenario specs/behaviours/retry.feature: A retry limit set in config applies to a scenario with no retry tag
  test "a config retry limit applies to a scenario with no retry tag on disk" do
    start_supervised!(%{
      id: :flaky_config_counter,
      start: {Agent, :start_link, [fn -> 0 end, [name: ExBdd.Integration.FlakyCounter]]}
    })

    Application.put_env(:ex_bdd, :retry, 1)

    try do
      {result, events} =
        OnDiskRun.run(
          """
          Feature: Config retry on disk
            Scenario: a flaky scenario without a tag
              Given a configured flaky step
          """,
          ~S"""
          defmodule ExBdd.Integration.ConfigFlakySteps do
            use ExBdd.StepDefinition

            step "a configured flaky step", context do
              attempt = Agent.get_and_update(ExBdd.Integration.FlakyCounter, fn n -> {n + 1, n + 1} end)
              ExBdd.BehaviorCase.Collector.record({:attempt, attempt})
              if attempt < 2, do: raise("flaky on attempt #{attempt}")
              context
            end
          end
          """
        )

      assert result.failures == 0
      assert BehaviorCase.count(events, {:attempt, 2}) == 1
    after
      Application.delete_env(:ex_bdd, :retry)
    end
  end

  # @scenario specs/behaviours/retry.feature: a retried attempt is numbered from one
  test "a retried attempt is numbered from one on disk" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: Numbered attempts on disk
          @retry-2
          Scenario: a numbered scenario
            Given a numbered step
        """,
        ~S"""
        defmodule ExBdd.Integration.NumberedSteps do
          use ExBdd.StepDefinition

          step "a numbered step", context do
            ExBdd.BehaviorCase.Collector.record({:retry_attempt, context.retry_attempt})
            if context.retry_attempt < 2, do: raise("numbered attempt")
            context
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, {:retry_attempt, 1}) == 1
    assert BehaviorCase.count(events, {:retry_attempt, 2}) == 1
  end
end
