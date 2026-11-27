defmodule Tools.Credo.HermeticUnitTestTest do
  use ExUnit.Case, async: true

  alias Tools.Credo.HermeticUnitTest

  # The check's pure core takes an AST, so no source file is read and no Credo service is started.
  defp violations(source) do
    source
    |> Code.string_to_quoted!()
    |> HermeticUnitTest.violations()
  end

  describe "flags a direct call to an impure API" do
    for {call, trigger} <- [
          {~s|File.read!("notes.txt")|, "File.read!"},
          {"System.tmp_dir!()", "System.tmp_dir!"},
          {"System.unique_integer([:positive])", "System.unique_integer"},
          {"System.monotonic_time(:millisecond)", "System.monotonic_time"},
          {"System.version()", "System.version"},
          {"Elixir.File.exists?(path)", "File.exists?"},
          {":os.type()", ":os.type"},
          {":rand.uniform(10)", ":rand.uniform"},
          {"DateTime.utc_now()", "DateTime.utc_now"},
          {"Process.sleep(1)", "Process.sleep"},
          {":timer.sleep(1)", ":timer.sleep"},
          {":gen_tcp.connect(host, 80, [])", ":gen_tcp.connect"},
          {":httpc.request(url)", ":httpc.request"},
          {"Port.open({:spawn, cmd}, [])", "Port.open"},
          {~s|Path.wildcard("test/**/*.exs")|, "Path.wildcard"},
          {~s|Application.get_env(:ex_bdd, :retry)|, "Application.get_env"},
          {~s|Code.require_file("helper.exs")|, "Code.require_file"},
          {":erlang.monotonic_time()", ":erlang.monotonic_time"}
        ] do
      test "#{trigger}" do
        assert [{1, unquote(trigger)}] = violations(unquote(call))
      end
    end

    test "a call in a pipe" do
      assert [{1, "File.read!"}] = violations("\"notes.txt\" |> File.read!()")
    end

    test "a function capture" do
      assert [{1, "File.exists?"}] = violations("Enum.map(paths, &File.exists?/1)")
    end

    test "a call through the Elixir alias prefix" do
      assert [{1, "File.read!"}] = violations(~s|Elixir.File.read!("notes.txt")|)
    end

    test "every call is reported once, in source order" do
      source = "File.read!(\"a\")\nSystem.tmp_dir!()\nFile.exists?(\"b\")\n"

      assert [{1, "File.read!"}, {2, "System.tmp_dir!"}, {3, "File.exists?"}] = violations(source)
    end
  end

  describe "reports a finding a human can act on" do
    test "reports the line of the call" do
      assert [{3, "File.read!"}] = violations("a = 1\nb = 2\nFile.read!(\"notes.txt\")\n")
    end

    test "the trigger names the API, never the arguments of the call" do
      assert [{1, trigger}] = violations(~s|File.read!("secret-token-value")|)

      assert trigger == "File.read!"
      refute HermeticUnitTest.message(trigger) =~ "secret-token-value"
    end
  end

  describe "leaves pure calls alone" do
    for call <- [
          "Enum.map([1], &(&1 + 1))",
          ~s|String.split("a,b", ",")|,
          ~s|Path.join("a", "b")|,
          ~s|Path.expand("a")|,
          "Map.fetch!(%{a: 1}, :a)",
          "Module.concat([A, B])",
          ":erlang.system_info(:schedulers)",
          ~s|MyApp.File.read!("x")|,
          ~s|read!("x")|
        ] do
      test "#{call}" do
        assert [] = violations(unquote(call))
      end
    end
  end
end
