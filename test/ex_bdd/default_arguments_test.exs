defmodule ExBdd.DefaultArgumentsTest do
  # async: false: the test sets the discovery app env every discovery reads, and compiling resets
  # the run coordinator.
  use ExUnit.Case, async: false

  @keys [:features, :steps, :support]

  setup do
    # An empty list is a configured pattern set that matches no file, so the zero-option calls stay off the file system.
    Enum.each(@keys, &Application.put_env(:ex_bdd, &1, []))
    on_exit(fn -> Enum.each(@keys, &Application.delete_env(:ex_bdd, &1)) end)
    :ok
  end

  test "compile_features!/0 with no options compiles an empty corpus to no modules" do
    assert ExBdd.compile_features!() == []
  end

  test "verify_features!/0 with no options rejects an empty corpus" do
    assert_raise ExBdd.VerificationError, ~r/No feature files were discovered/, fn ->
      ExBdd.verify_features!()
    end
  end
end
