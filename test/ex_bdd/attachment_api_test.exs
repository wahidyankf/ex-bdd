defmodule ExBdd.AttachmentApiTest do
  use ExUnit.Case, async: false

  # @scenario specs/behaviours/attachments.feature: attach, log, and link return the context unchanged
  test "attach, log, and link return the context unchanged" do
    ExBdd.RunCoordinator.ensure_started()
    context = %{answer: 42}

    assert ExBdd.attach(context, "a note", "text/plain") == context
    assert ExBdd.log(context, "a line of text") == context
    assert ExBdd.link(context, "https://example.invalid/evidence") == context
  end
end
