defmodule ExBdd.Integration.TableEscapesTest do
  use ExUnit.Case, async: false
  @moduletag :integration

  alias ExBdd.BehaviorCase
  alias ExBdd.OnDiskRun

  # @scenario specs/behaviours/advanced_features.feature: Escaped pipes and newlines in table cells
  test "escaped pipes and newlines in table cells reach the step unescaped" do
    {result, events} =
      OnDiskRun.run(
        ~S"""
        Feature: Escapes on disk
          Scenario: Escaped pipes and newlines in table cells
            Given a table with escaped cells:
              | text         |
              | a \| b       |
              | line1\nline2 |
            Then the escaped cells are read
        """,
        ~S"""
        defmodule ExBdd.Integration.EscapedTableSteps do
          use ExBdd.StepDefinition

          step "a table with escaped cells:", context do
            ExBdd.BehaviorCase.Collector.record({:cells, List.flatten(context.datatable.raw)})
            context
          end

          step "the escaped cells are read", _context do
            :ok
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, {:cells, ["text", "a | b", "line1\nline2"]}) == 1
  end
end
