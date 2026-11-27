defmodule MessagesConfigSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions

  # Writes a real NDJSON file, so these steps are integration level (C12) and live outside test/features.
  step "the features compile and run with the messages config", context do
    path =
      Path.join(
        System.tmp_dir!(),
        "corpus-config-messages-#{System.unique_integer([:positive])}.ndjson"
      )

    Application.put_env(:ex_bdd, :messages, path)

    try do
      modules =
        ExBdd.Compiler.compile_features!(
          features: ["test/fixtures/configuration/messages.feature"],
          steps: [],
          support: []
        )

      {run, _output} = ExBdd.BehaviorCase.run_isolated(modules)
      Map.merge(context, %{messages_path: path, config_run: run})
    after
      Application.delete_env(:ex_bdd, :messages)
    end
  end

  step "the messages config file holds a testRunStarted envelope", context do
    lines = context.messages_path |> File.read!() |> String.split("\n", trim: true)
    File.rm(context.messages_path)

    types = Enum.flat_map(lines, fn line -> line |> JSON.decode!() |> Map.keys() end)

    assert "testRunStarted" in types
    assert context.config_run.failures == 1
    context
  end
end
