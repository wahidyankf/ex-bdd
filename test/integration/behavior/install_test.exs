defmodule Mix.Tasks.ExBdd.InstallIntegrationTest do
  use ExUnit.Case, async: false
  @moduletag :integration

  import Igniter.Test

  # @scenario specs/behaviours/install.feature: mix ex_bdd.install wires test_helper.exs and mix.exs
  test "mix ex_bdd.install wires test_helper.exs and mix.exs" do
    dir = Path.join(System.tmp_dir!(), "ex_bdd_install_#{System.unique_integer([:positive])}")
    File.mkdir_p!(Path.join(dir, "test"))
    helper = Path.join(dir, "test/test_helper.exs")
    mix_exs = Path.join(dir, "mix.exs")
    File.write!(helper, "ExUnit.start()\n")

    try do
      installed =
        test_project(files: %{"test/test_helper.exs" => File.read!(helper)})
        |> Igniter.compose_task("ex_bdd.install")
        |> apply_igniter!()

      # The installed files go back to disk, and the assertions read them from there.
      File.write!(helper, installed.assigns.test_files["test/test_helper.exs"])
      File.write!(mix_exs, installed.assigns.test_files["mix.exs"])

      assert File.read!(helper) == "ExUnit.start()\nExBdd.compile_features!()\n"
      assert File.read!(mix_exs) =~ "~r/features\\/step_definitions/"
      assert File.read!(mix_exs) =~ "~r/features\\/support/"
    after
      File.rm_rf(dir)
    end
  end
end
