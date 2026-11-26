defmodule ExBdd.RuntimeErrorTest do
  use ExUnit.Case

  alias ExBdd.Gherkin.Step
  alias ExBdd.Runtime

  defmodule FailingSteps do
    use ExBdd.StepDefinition

    step "I fail with an error", _context do
      raise "deliberate failure"
    end
  end

  describe "error formatting in execute_step/3" do
    setup do
      step_registry = ExBdd.StepRegistry.new([FailingSteps])

      {:ok, step_registry: step_registry}
    end

    test "missing step definition includes context", %{step_registry: step_registry} do
      step = %Step{
        keyword: "Given",
        text: "this step does not exist",
        line: 5
      }

      context = %{
        feature_file: "test/features/example.feature",
        scenario_name: "Test scenario",
        step_history: [
          %Step{keyword: "Given", text: "a previous step"}
        ]
      }

      assert_raise ExBdd.StepError, fn ->
        Runtime.execute_step(context, step, step_registry)
      end
    end

    test "step failure includes enhanced formatting", %{step_registry: step_registry} do
      step = %Step{
        keyword: "When",
        text: "I fail with an error",
        line: 10
      }

      context = %{
        feature_file: "test/features/error.feature",
        scenario_name: "Error handling",
        step_history: []
      }

      error =
        assert_raise ExBdd.StepError, fn ->
          Runtime.execute_step(context, step, step_registry)
        end

      assert error.message =~ "deliberate failure"
    end
  end

  describe "PhoenixTest error formatting" do
    defmodule MockPhoenixTestSteps do
      use ExBdd.StepDefinition

      step "I click the submit button", _context do
        # Simulate a PhoenixTest error
        raise """
        Could not find any elements with selector "button" and text "Submit"

        Found these elements matching the selector "button":

        <button class="btn btn-primary">
          Save Draft
        </button>

        <button class="btn btn-secondary">
          Cancel
        </button>

        <button type="submit" disabled>
          Submit (disabled)
        </button>
        """
      end
    end

    test "formats HTML elements with proper indentation" do
      step_registry = ExBdd.StepRegistry.new([MockPhoenixTestSteps])

      step = %Step{
        keyword: "When",
        text: "I click the submit button",
        line: 15
      }

      context = %{
        feature_file: "test/features/form.feature",
        scenario_name: "Form submission",
        step_history: [
          %Step{keyword: "Given", text: "I am on the form page"},
          %Step{keyword: "And", text: "I have filled in the form"}
        ]
      }

      error =
        assert_raise ExBdd.StepError, fn ->
          Runtime.execute_step(context, step, step_registry)
        end

      # Check that the error message is properly formatted
      assert error.message =~ "Step failed:"
      assert error.message =~ "When I click the submit button"
      assert error.message =~ "in scenario \"Form submission\""
      assert error.message =~ "test/features/form.feature:16"

      # Check HTML formatting
      assert error.message =~ "Found these elements"
      assert error.message =~ "<button class=\"btn btn-primary\">"
      assert error.message =~ "Save Draft"

      # Check step history
      assert error.message =~ "Step execution history:"
      assert error.message =~ "[passed] Given I am on the form page"
      assert error.message =~ "[passed] And I have filled in the form"
      assert error.message =~ "[failed] When I click the submit button"
    end
  end

  defmodule FakeAssertionError do
    defexception [:message]
  end

  defmodule AssertionSteps do
    use ExBdd.StepDefinition

    step "the page shows buttons", _context do
      raise ExUnit.AssertionError,
        message:
          "Could not find any elements\n\nFound these elements:\n<button>\n  Save\n\n<a href=\"#\">Link</a>"
    end

    step "the page shows a named assertion", _context do
      raise FakeAssertionError,
        message:
          "Could not find any elements\n\nFound these elements:\n<button>\n  Save\n</button>"
    end
  end

  describe "assertion errors that list HTML elements" do
    test "an ExUnit assertion lists each element and keeps the text before the list" do
      step_registry = ExBdd.StepRegistry.new([AssertionSteps])
      step = %Step{keyword: "Then", text: "the page shows buttons", line: 3}

      context = %{
        feature_file: "test/features/buttons.feature",
        scenario_name: "Buttons",
        step_history: []
      }

      error =
        assert_raise ExBdd.StepError, fn ->
          Runtime.execute_step(context, step, step_registry)
        end

      assert error.message =~ "Could not find any elements"
      assert error.message =~ "Found these elements"
      assert error.message =~ "  <button>"
      assert error.message =~ "  <a href=\"#\">Link</a>"
    end

    test "a module named like an assertion error is formatted the same way" do
      step_registry = ExBdd.StepRegistry.new([AssertionSteps])
      step = %Step{keyword: "Then", text: "the page shows a named assertion", line: 4}

      context = %{
        feature_file: "test/features/buttons.feature",
        scenario_name: "Buttons",
        step_history: []
      }

      error =
        assert_raise ExBdd.StepError, fn ->
          Runtime.execute_step(context, step, step_registry)
        end

      assert error.message =~ "  <button>"
    end
  end
end
