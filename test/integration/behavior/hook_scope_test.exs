defmodule ExBdd.Integration.HookScopeTest do
  use ExUnit.Case, async: false
  @moduletag :integration

  alias ExBdd.BehaviorCase
  alias ExBdd.OnDiskRun

  # @scenario specs/behaviours/hook_execution_order.feature: A global before-scenario hook runs for every scenario
  test "a global before-scenario hook runs for every scenario" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: Global before-scenario on disk
          Scenario: first runs
            Given a plain scoped step
          Scenario: second runs
            Given a plain scoped step
        """,
        """
        defmodule ExBdd.Integration.ScopedPlainSteps do
          use ExBdd.StepDefinition

          step "a plain scoped step", _context do
            ExBdd.BehaviorCase.Collector.record(:plain_ran)
            :ok
          end
        end
        """,
        """
        defmodule ExBdd.Integration.GlobalBeforeScenarioHooks do
          use ExBdd.Hooks

          before_scenario context do
            ExBdd.BehaviorCase.Collector.record(:before_scenario)
            context
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, :before_scenario) == 2
    assert BehaviorCase.count(events, :plain_ran) == 2
  end

  # @scenario specs/behaviours/hook_outcomes.feature: The after-step hook sees the status of a passing step
  test "the after-step hook sees the status of a passing step on disk" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: After-step status on disk
          Scenario: a passing step
            Given a passing scoped step
        """,
        """
        defmodule ExBdd.Integration.PassingScopedSteps do
          use ExBdd.StepDefinition

          step "a passing scoped step", _context do
            :ok
          end
        end
        """,
        """
        defmodule ExBdd.Integration.AfterStepStatusHooks do
          use ExBdd.Hooks

          after_step context do
            ExBdd.BehaviorCase.Collector.record({:after_step, context.step_status})
            context
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, {:after_step, :passed}) == 1
  end
end
