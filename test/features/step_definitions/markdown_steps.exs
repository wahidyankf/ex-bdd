defmodule MarkdownSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions

  step "a Markdown feature file with a scenario and an outline with a table", context do
    assert File.regular?(ExBdd.MarkdownFixture.path())
    Map.put(context, :markdown_path, ExBdd.MarkdownFixture.path())
  end

  step "it is discovered alongside a plain feature file", context do
    discovered =
      ExBdd.Discovery.discover(
        features: [context.markdown_path, "test/fixtures/verification/valid.feature"],
        steps: [],
        support: []
      )

    Map.put(context, :discovered, discovered)
  end

  step "the discovered features include the Markdown feature file", context do
    assert Enum.any?(context.discovered.features, &(&1.file == context.markdown_path))
    context
  end

  # Counts the fixture's own step events, so other runs' events never change the number.
  step "the sub-run records {int} fixture steps", %{args: [count]} = context do
    assert ExBdd.BehaviorCase.count(context.sub_run.events, :fixture_step) == count
    context
  end
end
