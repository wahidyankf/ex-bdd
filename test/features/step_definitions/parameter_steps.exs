defmodule ParameterSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions

  # Step with {int} parameter
  step "a number {int}", %{args: [number]} = context do
    assert number == 42
    Map.put(context, :number, number)
  end

  # Step with {float} parameter
  step "a decimal {float}", %{args: [float]} = context do
    assert float == 3.14
    Map.put(context, :float, float)
  end

  # Step with {string} and {word} parameters
  step "I click {string} on the {word}", context do
    [button_text, form_name] = context.args
    assert button_text == "Submit"
    assert form_name == "form"
    Map.put(context, :clicked, button_text)
  end

  # Step with {string} and {word} parameters that uses the context from previous steps
  step "I should see {string} message on the {word}", context do
    [message, location] = context.args
    assert message == "Success"
    assert location == "dashboard"
    assert context[:number] == 42
    assert context[:float] == 3.14
    assert context[:clicked] == "Submit"
    Map.put(context, :message, message)
  end

  # Step with {atom} parameter
  step "status is {atom}", %{args: [status]} = context do
    Map.put(context, :status, status)
  end

  step "the status should be the atom {atom}", %{args: [expected]} = context do
    assert context[:status] == expected
    context
  end

  # Steps with optional text (s) for pluralization
  step "I have {int} cucumber(s)", %{args: [count]} = context do
    total = Map.get(context, :cucumber_count, 0) + count
    Map.put(context, :cucumber_count, total)
  end

  step "the total cucumber count should be {int}", %{args: [expected]} = context do
    assert context[:cucumber_count] == expected
    context
  end

  # Steps with alternation
  step "I am on the {word} page", %{args: [page]} = context do
    Map.put(context, :page, page)
  end

  step "I click/tap the {word} button", %{args: [button]} = context do
    Map.put(context, :interacted, button)
  end

  step "I should have interacted", context do
    assert context[:interacted] != nil
    context
  end

  step "the carton holds {int?} eggs", %{args: [count]} = context do
    Map.put(context, :eggs, count)
  end

  step "the egg count is nil", context do
    assert context[:eggs] == nil
    context
  end

  step "the egg count is {int}", %{args: [expected]} = context do
    assert context[:eggs] == expected
    context
  end

  step "a literal \\{brace\\} and a path\\/to\\/file with call\\(\\)", context do
    Map.put(context, :literal_step, true)
  end

  step "the literal step has run", context do
    assert context[:literal_step] == true
    context
  end

  step "seat {seat} is reserved", %{args: [seat]} = context do
    Map.put(context, :reserved, seat)
  end

  step "the reserved seat is {string}", %{args: [expected]} = context do
    assert context.reserved == %{seat: expected}
    context
  end

  step "the expression {string} is compiled", %{args: [pattern]} = context do
    Map.put(context, :compiled, ExBdd.Expression.compile(pattern))
  end

  step "the compiled expression matches {string}", %{args: [text]} = context do
    Map.put(context, :match_result, ExBdd.Expression.match(text, context.compiled))
  end

  step "the match result is {string}", %{args: [expected]} = context do
    assert inspect(context.match_result, charlists: :as_lists) == expected
    context
  end
end
