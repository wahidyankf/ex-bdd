defmodule MessagesStreamSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions

  step "the Messages builders make a test run started envelope for {string}",
       %{args: [id]} = context do
    Map.put(context, :built, ExBdd.Messages.test_run_started(id, ExBdd.Messages.timestamp(0)))
  end

  step "the built envelope is a testRunStarted envelope for {string}", %{args: [id]} = context do
    assert %{testRunStarted: %{id: ^id}} = context.built
    assert Map.keys(context.built) == [:testRunStarted]
    context
  end

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
