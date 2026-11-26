defmodule Tools.Credo.HermeticUnitTest do
  @moduledoc """
  Repository-owned Credo check for C12 and C21 of the test and gate contract: a unit test touches nothing.

  It flags a direct call to a clock, file system, network, environment, sleep, or randomness API. The check is scoped
  in `.credo.exs` to unit-test paths. Integration tests live under `test/integration/`, outside that scope, so the
  check never needs to read a tag.

  The check sees only calls written in the file it checks. A call made inside library code that a unit test reaches
  is not visible to it.
  """

  use Credo.Check,
    id: "EX9100",
    base_priority: :high,
    category: :warning,
    explanations: [
      check: """
      A unit test touches nothing: no clock, file system, network, environment, process, or randomness.

      Pass the dependency in as an argument (a reader, a clock, a file list) and keep the assertion, or move the test
      to test/integration/ with its scenario bindings.
      """
    ]

  # Modules whose every function touches the machine.
  @banned_modules [File, System, Port]

  # Erlang modules whose every function touches the machine.
  @banned_erlang_modules [
    :os,
    :rand,
    :random,
    :file,
    :filelib,
    :httpc,
    :gen_tcp,
    :gen_udp,
    :ssl,
    :inet
  ]

  # Individual functions that read a clock, sleep, reach the file system or environment, or load code.
  @banned_functions [
    {DateTime, :utc_now},
    {DateTime, :now},
    {NaiveDateTime, :utc_now},
    {NaiveDateTime, :local_now},
    {Date, :utc_today},
    {Time, :utc_now},
    {Process, :sleep},
    {Path, :wildcard},
    {Application, :get_env},
    {Application, :fetch_env},
    {Application, :fetch_env!},
    {Application, :get_all_env},
    {Code, :require_file},
    {Code, :eval_file},
    {Code, :compile_file},
    {:timer, :sleep},
    {:timer, :send_after},
    {:timer, :apply_after},
    {:timer, :send_interval},
    {:timer, :apply_interval},
    {:erlang, :monotonic_time},
    {:erlang, :system_time}
  ]

  @impl true
  def run(%SourceFile{} = source_file, params) do
    ctx = Context.build(source_file, params, __MODULE__)

    source_file
    |> SourceFile.ast()
    |> violations()
    |> Enum.map(fn {line_no, trigger} -> issue_for(ctx, line_no, trigger) end)
  end

  @doc false
  # The pure core: the line and the called API (module and function, never its arguments) of each impure call in an AST.
  def violations(ast) do
    ast
    |> Credo.Code.prewalk(&collect/2, [])
    |> Enum.reverse()
  end

  @doc false
  def message(trigger) do
    "Unit tests must not call #{trigger}. Inject the dependency, or move the test to test/integration/."
  end

  defp collect({{:., meta, [module_ast, function]}, _, args} = ast, acc)
       when is_atom(function) and is_list(args) do
    case banned_name(module_ast, function) do
      nil -> {ast, acc}
      name -> {ast, [{meta[:line], name} | acc]}
    end
  end

  defp collect(ast, acc), do: {ast, acc}

  defp banned_name(module_ast, function) do
    with module when is_atom(module) <- resolve(module_ast),
         true <- banned?(module, function) do
      "#{inspect(module)}.#{function}"
    else
      _ -> nil
    end
  end

  defp resolve({:__aliases__, _, parts}) when is_list(parts) do
    if Enum.all?(parts, &is_atom/1), do: Module.concat(parts)
  end

  defp resolve(module) when is_atom(module), do: module
  defp resolve(_), do: nil

  defp banned?(module, function) do
    module in @banned_modules or module in @banned_erlang_modules or
      {module, function} in @banned_functions
  end

  defp issue_for(ctx, line_no, trigger) do
    format_issue(ctx, message: message(trigger), trigger: trigger, line_no: line_no)
  end
end
