defmodule ExBdd.Integration.RegexStepsTest do
  use ExUnit.Case, async: false
  @moduletag :integration

  alias ExBdd.BehaviorCase
  alias ExBdd.OnDiskRun

  # @scenario specs/behaviours/regex_steps.feature: regex captures arrive as strings
  test "regex captures arrive as strings" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: Regex captures on disk
          Scenario: captures arrive as strings
            Given the order is 3 apples for 12
        """,
        """
        defmodule ExBdd.Integration.RegexCaptureSteps do
          use ExBdd.StepDefinition
          import ExUnit.Assertions

          step ~r/^the order is ([0-9]+) apples for ([0-9]+)$/, %{args: [count, price]} do
            assert is_binary(count) and is_binary(price)
            ExBdd.BehaviorCase.Collector.record({:captured, count, price})
            :ok
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, {:captured, "3", "12"}) == 1
  end

  # @scenario specs/behaviours/regex_steps.feature: optional regex groups are nil when absent
  test "optional regex groups are nil when absent" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: Optional regex groups on disk
          Scenario: an absent optional group
            Given a item
        """,
        """
        defmodule ExBdd.Integration.RegexOptionalSteps do
          use ExBdd.StepDefinition
          import ExUnit.Assertions

          step ~r/^a(?: ([a-z]+))? item$/, %{args: [color]} do
            assert color == nil
            ExBdd.BehaviorCase.Collector.record(:absent_group)
            :ok
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, :absent_group) == 1
  end
end
