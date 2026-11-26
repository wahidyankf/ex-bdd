defmodule AttachmentSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions

  step "a context holding a value", context do
    Map.put(context, :kept, "value")
  end

  step "I attach text, a log line, and a link", context do
    attached =
      context
      |> ExBdd.attach("a note", "text/plain")
      |> ExBdd.log("a log line")
      |> ExBdd.link("https://example.com/run/1")

    assert attached == context
    attached
  end

  step "the context still holds its value", context do
    assert context.kept == "value"
    context
  end
end
