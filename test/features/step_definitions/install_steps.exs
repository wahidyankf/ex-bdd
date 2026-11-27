defmodule InstallSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions
  import Igniter.Test

  step "the ex_bdd.install task runs on a new project", context do
    installed =
      test_project()
      |> Igniter.compose_task("ex_bdd.install")
      |> apply_igniter!()

    Map.put(context, :installed, installed)
  end

  step "test_helper.exs calls ExBdd.compile_features!", context do
    helper = context.installed.assigns.test_files["test/test_helper.exs"]
    assert helper =~ "ExBdd.compile_features!()"
    context
  end

  step "mix.exs points its test paths at the step definitions and support", context do
    mix = context.installed.assigns.test_files["mix.exs"]
    assert mix =~ "step_definitions"
    assert mix =~ "support"
    context
  end
end
