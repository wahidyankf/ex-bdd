defmodule ExBdd.AsyncContextTest do
  use ExUnit.Case, async: false

  alias ExBdd.BehaviorCase

  defmodule Steps do
    @moduledoc false
    use ExBdd.StepDefinition

    step "a value is set", _context do
      %{shared: 7}
    end

    step "the value set earlier is still there", %{shared: 7} do
      :ok
    end
  end

  # @scenario specs/behaviours/async_example.feature: Steps of an async scenario share its context
  test "steps of an async scenario share their context" do
    result =
      BehaviorCase.run_feature(
        """
        @async
        Feature: Async context
          Scenario: a later step reads what an earlier step set
            Given a value is set
            Then the value set earlier is still there
        """,
        steps: [Steps]
      )

    assert result.failures == 0
    assert result.passed == 1
  end
end
