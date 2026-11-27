defmodule ExBdd.Integration.AsyncTest do
  use ExUnit.Case, async: false
  @moduletag :integration

  alias ExBdd.BehaviorCase
  alias ExBdd.OnDiskRun

  # @scenario specs/behaviours/async_example.feature: Steps of an async scenario share its context
  test "steps of an async scenario share their context" do
    {result, events} =
      OnDiskRun.run(
        """
        @async
        Feature: Async context on disk
          Scenario: a later step reads what an earlier step set
            Given the async context is set
            Then the async context is still there
        """,
        """
        defmodule ExBdd.Integration.AsyncContextSteps do
          use ExBdd.StepDefinition

          step "the async context is set", _context do
            %{async_value: 7}
          end

          step "the async context is still there", %{async_value: 7} do
            ExBdd.BehaviorCase.Collector.record(:async_checked)
            :ok
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, :async_checked) == 1
  end
end
