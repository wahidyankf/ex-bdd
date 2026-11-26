defmodule ExBdd.AfterStepTest do
  use ExUnit.Case, async: false

  alias ExBdd.BehaviorCase
  alias ExBdd.BehaviorCase.Collector

  defmodule Steps do
    @moduledoc false
    use ExBdd.StepDefinition

    step "a passing step", _context do
      :ok
    end

    step "a failing step", _context do
      raise "failed on purpose"
    end

    step "a pending step", _context do
      :pending
    end

    step "a skipped step", _context do
      :skipped
    end
  end

  defmodule ObserveHooks do
    @moduledoc false
    use ExBdd.Hooks

    after_step "@observe", context do
      Collector.record({:after_step, context.step_status})
      :ok
    end
  end

  # @scenario specs/behaviours/hook_outcomes.feature: The after-step hook sees the status of a passing step
  test "the after-step hook sees the status of a passing step" do
    result =
      BehaviorCase.run_feature(
        """
        @observe
        Feature: After step, passing
          Scenario: a passing step
            Given a passing step
        """,
        steps: [Steps],
        hooks: [ObserveHooks]
      )

    assert result.failures == 0
    assert {:after_step, :passed} in result.events
  end

  # @scenario specs/behaviours/hook_outcomes.feature: The after_step hook sees failed, pending, and skipped steps
  # @scenario specs/behaviours/hook_outcomes.feature: The after_step hook sees failed, pending, and skipped steps
  test "the after-step hook sees failed, pending, and skipped steps" do
    result =
      BehaviorCase.run_feature(
        """
        Feature: After step, other outcomes
          @observe
          Scenario: a failing step
            Given a failing step

          @observe
          Scenario: a pending step
            Given a pending step

          @observe
          Scenario: a skipped step
            Given a skipped step
        """,
        steps: [Steps],
        hooks: [ObserveHooks]
      )

    assert {:after_step, :failed} in result.events
    assert {:after_step, :pending} in result.events
    assert {:after_step, :skipped} in result.events
  end
end
