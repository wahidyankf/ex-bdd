defmodule GherkinParseSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions
  alias ExBdd.Gherkin.Parser

  step "this Gherkin text:", context do
    Map.put(context, :text, context.docstring)
  end

  step "this Markdown text:", context do
    Map.put(context, :text, context.docstring)
  end

  step "the parser reads the text", context do
    Map.put(context, :feature, Parser.parse(context.text))
  end

  step "the parser reads the text as {string}", %{args: [path]} = context do
    try do
      Map.put(context, :feature, Parser.parse(context.text, path))
    rescue
      error in ExBdd.Gherkin.ParseError -> Map.put(context, :parse_error, error)
    end
  end

  step "the parsed feature is named {string} with {int} scenario(s)",
       %{args: [name, count]} = context do
    assert context.feature.name == name
    assert length(context.feature.scenarios) == count
    context
  end

  step "the parsed feature has the tag {string}", %{args: [tag]} = context do
    assert tag in context.feature.tags
    context
  end

  step "the parser raises a parse error whose message starts with {string}",
       %{args: [prefix]} = context do
    assert %ExBdd.Gherkin.ParseError{} = context.parse_error
    assert String.starts_with?(Exception.message(context.parse_error), prefix)
    context
  end
end
