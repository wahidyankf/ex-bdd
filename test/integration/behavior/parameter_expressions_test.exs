defmodule ExBdd.Integration.ParameterExpressionsTest do
  use ExUnit.Case, async: false
  @moduletag :integration

  alias ExBdd.BehaviorCase
  alias ExBdd.OnDiskRun

  # @scenario specs/behaviours/parameters.feature: Testing different parameter types
  test "{int}, {float}, and {string} arrive converted" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: Typed parameters on disk
          Scenario: Testing different parameter types
            Given a number 42
            And a decimal 3.14
            When I click "Submit" on the form
        """,
        """
        defmodule ExBdd.Integration.TypedParameterSteps do
          use ExBdd.StepDefinition
          import ExUnit.Assertions

          step "a number {int}", %{args: [number]} do
            assert is_integer(number)
            ExBdd.BehaviorCase.Collector.record({:number, number})
            :ok
          end

          step "a decimal {float}", %{args: [decimal]} do
            assert is_float(decimal)
            ExBdd.BehaviorCase.Collector.record({:decimal, decimal})
            :ok
          end

          step "I click {string} on the form", %{args: [label]} do
            ExBdd.BehaviorCase.Collector.record({:clicked, label})
            :ok
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, {:number, 42}) == 1
    assert BehaviorCase.count(events, {:decimal, 3.14}) == 1
    assert BehaviorCase.count(events, {:clicked, "Submit"}) == 1
  end

  # @scenario specs/behaviours/parameters.feature: Atom parameter extraction
  test "{atom} arrives as an atom" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: Atom parameter on disk
          Scenario: Atom parameter extraction
            Given status is pending
            Then the status should be the atom pending
        """,
        """
        defmodule ExBdd.Integration.AtomParameterSteps do
          use ExBdd.StepDefinition

          step "status is {atom}", %{args: [status]} do
            ExBdd.BehaviorCase.Collector.record({:status, status})
            :ok
          end

          step "the status should be the atom {atom}", %{args: [expected]} do
            ExBdd.BehaviorCase.Collector.record({:expected, expected})
            :ok
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, {:status, :pending}) == 1
    assert BehaviorCase.count(events, {:expected, :pending}) == 1
  end

  # @scenario specs/behaviours/parameters.feature: Optional text for pluralization
  test "optional text in a pattern matches with and without it" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: Optional text on disk
          Scenario: Optional text for pluralization
            Given I have 1 cucumber
            And I have 5 cucumbers
            Then the total cucumber count should be 6
        """,
        """
        defmodule ExBdd.Integration.PluralSteps do
          use ExBdd.StepDefinition
          import ExUnit.Assertions

          step "I have {int} cucumber(s)", %{args: [count]} = context do
            Map.update(context, :cucumbers, count, &(&1 + count))
          end

          step "the total cucumber count should be {int}", %{args: [total]} = context do
            assert context.cucumbers == total
            ExBdd.BehaviorCase.Collector.record(:total_checked)
            context
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, :total_checked) == 1
  end

  # @scenario specs/behaviours/parameters.feature: Alternation matching
  test "click/tap matches the first option" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: Alternation on disk
          Scenario: Alternation matching
            Given I am on the home page
            When I click the submit button
            Then I should have interacted
        """,
        """
        defmodule ExBdd.Integration.FirstAlternationSteps do
          use ExBdd.StepDefinition

          step "I am on the home page", _context do
            :ok
          end

          step "I click/tap the submit button", _context do
            ExBdd.BehaviorCase.Collector.record(:interacted)
            :ok
          end

          step "I should have interacted", _context do
            :ok
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, :interacted) == 1
  end

  # @scenario specs/behaviours/parameters.feature: Alternation matches the second word of click/tap
  test "click/tap matches the second word" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: Second alternation on disk
          Scenario: Alternation matches the second word of click/tap
            Given I am on the home page
            When I tap the submit button
            Then I should have interacted
        """,
        """
        defmodule ExBdd.Integration.SecondAlternationSteps do
          use ExBdd.StepDefinition

          step "I am on the home page", _context do
            :ok
          end

          step "I click/tap the submit button", _context do
            ExBdd.BehaviorCase.Collector.record(:interacted)
            :ok
          end

          step "I should have interacted", _context do
            :ok
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, :interacted) == 1
  end

  # @scenario specs/behaviours/parameters.feature: Escaped characters in a step pattern match literal step text
  test "escaped braces, slashes, and parentheses match literal step text" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: Escaped patterns on disk
          Scenario: Escaped characters in a step pattern match literal step text
            When a literal {brace} and a path/to/file with call()
            Then the literal step has run
        """,
        ~S"""
        defmodule ExBdd.Integration.EscapedPatternSteps do
          use ExBdd.StepDefinition

          step "a literal \\{brace\\} and a path\\/to\\/file with call\\(\\)", _context do
            ExBdd.BehaviorCase.Collector.record(:literal_ran)
            :ok
          end

          step "the literal step has run", _context do
            :ok
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, :literal_ran) == 1
  end

  # @scenario specs/behaviours/parameters.feature: The expression API returns typed arguments for matching text
  test "{int} arguments arrive as integers" do
    {result, events} =
      OnDiskRun.run(
        """
        Feature: Typed arguments on disk
          Scenario: The expression API returns typed arguments for matching text
            Given I have 42 items
        """,
        """
        defmodule ExBdd.Integration.TypedArgumentSteps do
          use ExBdd.StepDefinition
          import ExUnit.Assertions

          step "I have {int} items", %{args: [count]} do
            assert is_integer(count)
            ExBdd.BehaviorCase.Collector.record({:count, count})
            :ok
          end
        end
        """
      )

    assert result.failures == 0
    assert BehaviorCase.count(events, {:count, 42}) == 1
  end
end
