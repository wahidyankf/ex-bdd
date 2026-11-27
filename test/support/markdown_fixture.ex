defmodule ExBdd.MarkdownFixture do
  @moduledoc """
  The Markdown feature fixture at `test/fixtures/markdown/markdown.feature.md`.

  The fixture is input data for ExBdd's Markdown feature support, not part of the
  behaviour corpus under `specs/behaviours/`. `Steps` holds the steps the fixture
  itself uses, so a run of the fixture can execute them.
  """

  @path "test/fixtures/markdown/markdown.feature.md"

  @doc "The repository-relative path of the fixture."
  def path, do: @path

  defmodule Steps do
    @moduledoc false
    use ExBdd.StepDefinition
    import ExUnit.Assertions

    alias ExBdd.BehaviorCase.Collector

    step "a Markdown feature file", _context do
      Collector.record(:fixture_step)
      :ok
    end

    step "it is discovered alongside plain feature files", _context do
      Collector.record(:fixture_step)
      :ok
    end

    step "its scenarios run like any other", _context do
      Collector.record(:fixture_step)
      :ok
    end

    step "a basket with {int} markdown cucumbers", %{args: [count]} do
      Collector.record(:fixture_step)
      assert count in [1, 3]
      :ok
    end
  end

  @doc "Returns the fixture text."
  def source, do: File.read!(path())
end
