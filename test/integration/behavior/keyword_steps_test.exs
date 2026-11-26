defmodule ExBdd.Integration.KeywordStepsTest do
  use ExUnit.Case, async: false
  @moduletag :integration

  alias ExBdd.BehaviorCase
  alias ExBdd.OnDiskRun

  # @scenario specs/behaviours/simple.feature: But steps run like And steps
  test "a But step runs like an And step on disk" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: But steps on disk
          Scenario: a but step after a given step
            Given a counted step
            But a counted step
        """,
        """
        defmodule ExBdd.Integration.KeywordCountedSteps do
          use ExBdd.StepDefinition

          step "a counted step", _context do
            ExBdd.BehaviorCase.Collector.record(:counted)
            :ok
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, :counted) == 2
  end
end
