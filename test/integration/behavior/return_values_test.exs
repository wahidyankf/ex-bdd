defmodule ExBdd.Integration.ReturnValuesTest do
  use ExUnit.Case, async: false
  @moduletag :integration

  alias ExBdd.BehaviorCase
  alias ExBdd.OnDiskRun

  # @scenario specs/behaviours/return_values.feature: Return a map directly
  test "a step that returns a map merges it into the context" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: Return a map on disk
          Scenario: Return a map directly
            Given a step that returns a map
            Then the map value is merged
        """,
        """
        defmodule ExBdd.Integration.ReturnMapSteps do
          use ExBdd.StepDefinition

          step "a step that returns a map", _context do
            %{map_value: 1}
          end

          step "the map value is merged", %{map_value: 1} do
            ExBdd.BehaviorCase.Collector.record(:map_merged)
            :ok
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, :map_merged) == 1
  end

  # @scenario specs/behaviours/return_values.feature: Return an :ok atom
  test "an :ok return leaves the context as it was" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: Return an ok atom on disk
          Scenario: Return an :ok atom
            Given a step that returns a map
            When a step that returns ok
            Then the map value is still there
        """,
        """
        defmodule ExBdd.Integration.ReturnOkSteps do
          use ExBdd.StepDefinition

          step "a step that returns a map", _context do
            %{map_value: 1}
          end

          step "a step that returns ok", _context do
            :ok
          end

          step "the map value is still there", %{map_value: 1} do
            ExBdd.BehaviorCase.Collector.record(:map_kept)
            :ok
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, :map_kept) == 1
  end

  # @scenario specs/behaviours/return_values.feature: Return {:ok, map} tuple
  test "an {:ok, map} return merges the map into the context" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: Return an ok tuple on disk
          Scenario: Return {:ok, map} tuple
            Given a step that returns an ok tuple
            Then the tuple value is merged
        """,
        """
        defmodule ExBdd.Integration.ReturnTupleSteps do
          use ExBdd.StepDefinition

          step "a step that returns an ok tuple", _context do
            {:ok, %{tuple_value: 2}}
          end

          step "the tuple value is merged", %{tuple_value: 2} do
            ExBdd.BehaviorCase.Collector.record(:tuple_merged)
            :ok
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, :tuple_merged) == 1
  end

  # @scenario specs/behaviours/return_values.feature: Return keyword list
  test "a keyword list return merges into the context" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: Return a keyword list on disk
          Scenario: Return keyword list
            Given a step that returns a keyword list
            Then the keyword value is merged
        """,
        """
        defmodule ExBdd.Integration.ReturnKeywordSteps do
          use ExBdd.StepDefinition

          step "a step that returns a keyword list", _context do
            [keyword_value: 3]
          end

          step "the keyword value is merged", %{keyword_value: 3} do
            ExBdd.BehaviorCase.Collector.record(:keyword_merged)
            :ok
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, :keyword_merged) == 1
  end
end
