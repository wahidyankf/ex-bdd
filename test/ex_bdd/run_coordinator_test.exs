defmodule ExBdd.RunCoordinatorTest do
  # async: false — the coordinator is a named singleton and these tests
  # reset its run id.
  use ExUnit.Case, async: false

  alias ExBdd.RunCoordinator

  test "ensure_started starts the coordinator and returns a run id" do
    run_id = RunCoordinator.ensure_started()

    assert is_integer(run_id)
    assert RunCoordinator.run_id() == run_id
  end

  test "ensure_started on a running coordinator resets to a fresh run id" do
    first = RunCoordinator.ensure_started()
    second = RunCoordinator.ensure_started()

    assert second != first
    assert RunCoordinator.run_id() == second
  end

  defmodule BeforeAllProbe do
    def increment(context) do
      count = Agent.get_and_update(__MODULE__.Counter, &{&1 + 1, &1 + 1})
      {:ok, Map.put(context, :count, count)}
    end

    # The first time it runs, the run is reset (a new `compile_features!`,
    # e.g. under `mix test.watch`) while the hook is still executing, so
    # its result reaches the coordinator after the reset
    def reset_run_mid_hook(context) do
      {:ok, context} = increment(context)
      if context.count == 1, do: ExBdd.RunCoordinator.ensure_started()
      {:ok, context}
    end
  end

  describe "before_all_context/1" do
    test "executes before_all hooks once and caches the merged context" do
      {:ok, _} = Agent.start(fn -> 0 end, name: BeforeAllProbe.Counter)
      on_exit(fn -> Agent.stop(BeforeAllProbe.Counter) end)

      RunCoordinator.ensure_started()
      hooks = [{:before_all, nil, nil, {BeforeAllProbe, :increment}}]

      assert {:ok, %{count: 1}} = RunCoordinator.before_all_context(hooks)
      # Second call returns the cached result without re-running the hook
      assert {:ok, %{count: 1}} = RunCoordinator.before_all_context(hooks)
      assert Agent.get(BeforeAllProbe.Counter, & &1) == 1

      # A reset clears the cache: the hook runs again for the new run
      RunCoordinator.ensure_started()
      assert {:ok, %{count: 2}} = RunCoordinator.before_all_context(hooks)
    end

    test "a result that arrives after the run was reset does not settle the new run" do
      {:ok, _} = Agent.start(fn -> 0 end, name: BeforeAllProbe.Counter)
      on_exit(fn -> Agent.stop(BeforeAllProbe.Counter) end)

      RunCoordinator.ensure_started()
      hooks = [{:before_all, nil, nil, {BeforeAllProbe, :reset_run_mid_hook}}]

      # The caller from the old run still gets its own hooks' result
      assert {:ok, %{count: 1}} = RunCoordinator.before_all_context(hooks)

      # The new run has not run its hooks: the stale result was ignored, so
      # its first caller runs them afresh
      assert {:ok, %{count: 2}} = RunCoordinator.before_all_context(hooks)
      assert {:ok, %{count: 2}} = RunCoordinator.before_all_context(hooks)
    end

    test "returns {:ok, %{}} without hooks and without a coordinator" do
      assert {:ok, %{}} = RunCoordinator.before_all_context([])
    end
  end

  describe "run_after_all/1" do
    defmodule AfterAllProbe do
      # run_after_all executes hooks in the calling process — the test
      # process here — so self() is the test pid
      def record(context) do
        send(self(), {:after_all_ran, context.suite_result})
        :ok
      end

      def explode(_context), do: raise("cleanup went wrong")
    end

    test "claims registered after_all hooks exactly once" do
      RunCoordinator.ensure_started()
      RunCoordinator.register_after_all([{:after_all, nil, nil, {AfterAllProbe, :record}}])

      suite_result = %{total: 5, failures: 0}
      assert :ok = RunCoordinator.run_after_all(suite_result)
      assert_receive {:after_all_ran, ^suite_result}

      # Already claimed: nothing runs the second time
      assert :ok = RunCoordinator.run_after_all(suite_result)
      refute_receive {:after_all_ran, _}
    end

    test "a raising after_all hook fails the run with its own error" do
      RunCoordinator.ensure_started()
      RunCoordinator.register_after_all([{:after_all, nil, nil, {AfterAllProbe, :explode}}])

      assert_raise RuntimeError, "cleanup went wrong", fn ->
        RunCoordinator.run_after_all(%{total: 0, failures: 0})
      end
    end
  end

  defmodule HookResults do
    def ok(_context), do: :ok
    def map(_context), do: %{from_map: 1}
    def keyword(_context), do: [from_keyword: 2]
    def failed(_context), do: {:error, :boom}
    def invalid(_context), do: :nope
    def raised(_context), do: raise("exploded")
  end

  defmodule BeforeAllPark do
    # Parks inside its before_all hook until the test kills the runner.
    def park(_context) do
      send(:ex_bdd_run_coordinator_test, :parked)

      receive do
        :never_sent -> {:ok, %{}}
      end
    end
  end

  defmodule AfterAllFailing do
    def fail(_context), do: {:error, :cleanup_failed}
  end

  defp before_all_result(name, fun) do
    RunCoordinator.ensure_started()
    RunCoordinator.before_all_context([{:before_all, nil, name, {HookResults, fun}}])
  end

  defp await_waiters(attempts \\ 500) do
    case :sys.get_state(RunCoordinator) do
      %{before_all: {:running, %{waiters: [_ | _]}}} ->
        :ok

      _not_yet when attempts > 0 ->
        receive do
        after
          2 -> await_waiters(attempts - 1)
        end

      _not_yet ->
        flunk("no caller queued behind the running before_all hook")
    end
  end

  describe "before_all_context/1 hook result shapes" do
    test "a hook returning :ok leaves the context empty" do
      assert {:ok, %{}} = before_all_result("ok", :ok)
    end

    test "a hook returning a map merges it into the context" do
      assert {:ok, %{from_map: 1}} = before_all_result("map", :map)
    end

    test "a hook returning a keyword list merges it into the context" do
      assert {:ok, %{from_keyword: 2}} = before_all_result("keyword", :keyword)
    end

    test "a hook returning an error fails the run and names the hook" do
      assert {:error, message} = before_all_result("setup", :failed)
      assert message =~ "BeforeAll hook \"setup\" failed: :boom"
    end

    test "a hook returning a value of another shape fails the run" do
      assert {:error, message} = before_all_result("setup", :invalid)
      assert message =~ "returned invalid value: :nope"
    end

    test "a hook that raises fails the run with the exception" do
      assert {:error, message} = before_all_result("setup", :raised)
      assert message =~ "exploded"
    end
  end

  describe "a before_all runner that dies mid-hook" do
    test "queued callers receive the process-exit error" do
      RunCoordinator.ensure_started()
      Process.register(self(), :ex_bdd_run_coordinator_test)
      hooks = [{:before_all, nil, "park", {BeforeAllPark, :park}}]

      runner = spawn(fn -> RunCoordinator.before_all_context(hooks) end)
      assert_receive :parked

      waiter = Task.async(fn -> RunCoordinator.before_all_context(hooks) end)
      await_waiters()
      Process.exit(runner, :kill)

      assert {:error, message} = Task.await(waiter)
      assert message =~ "process exited"
    end
  end

  describe "record_attachment/2" do
    test "keeps attachments in the order they were recorded" do
      RunCoordinator.ensure_started()
      first = %ExBdd.Attachment{body: "one", media_type: "text/plain", encoding: :identity}
      second = %ExBdd.Attachment{body: "two", media_type: "text/plain", encoding: :identity}

      assert :ok = RunCoordinator.record_attachment(first)
      assert :ok = RunCoordinator.record_attachment(second, nil)
      assert RunCoordinator.attachments() == [first, second]
    end

    test "starts the coordinator when it is not running and records the attachment" do
      RunCoordinator.ensure_started()
      :ok = GenServer.stop(RunCoordinator)
      attachment = %ExBdd.Attachment{body: "x", media_type: "text/plain", encoding: :identity}

      assert :ok = RunCoordinator.record_attachment(attachment)
      assert RunCoordinator.attachments() == [attachment]
    end
  end

  describe "run_after_all/1 with messages enabled" do
    test "a run-level hook is recorded and a failing one is replayed by name" do
      RunCoordinator.ensure_started()

      :ok =
        RunCoordinator.configure_messages(%{
          path: "unused-run-hook.ndjson",
          envelopes: [],
          next_id: 1,
          step_definition_ids: %{},
          hook_ids: %{}
        })

      on_exit(fn -> RunCoordinator.ensure_started() end)
      RunCoordinator.register_after_all([{:after_all, nil, "cleanup", {AfterAllFailing, :fail}}])

      error =
        assert_raise RuntimeError, fn ->
          RunCoordinator.run_after_all(%{total: 0, failures: 0})
        end

      assert error.message =~ "AfterAll hook \"cleanup\" failed: :cleanup_failed"
    end
  end
end
