defmodule ExBdd.Gherkin.MarkdownCorpusTest do
  # Sync: the events of a nested run are read from the shared Collector, so no
  # async test may run beside it.
  use ExUnit.Case, async: false

  describe "Markdown feature files in a corpus" do
    # credo:disable-for-next-line Credo.Check.Readability.MaxLineLength
    # @scenario specs/behaviours/markdown_feature_files.feature: feature files written in Markdown are discovered and their scenarios run like plain ones
    test "feature files written in Markdown are discovered and their scenarios run like plain ones" do
      path = ExBdd.MarkdownFixture.path()

      discovered = ExBdd.Discovery.discover(features: [path], steps: [], support: [])
      assert [feature] = discovered.features
      assert feature.name == "Markdown feature files"

      run =
        ExBdd.BehaviorCase.run_feature(ExBdd.MarkdownFixture.source(),
          steps: [ExBdd.MarkdownFixture.Steps],
          file: ExBdd.BehaviorCase.unique_markdown_path()
        )

      # Three steps in the first scenario and one per outline row. The count is by
      # event, since a nested run also reports the modules other tests left pending.
      assert ExBdd.BehaviorCase.count(run.events, :fixture_step) == 5
    end
  end
end
