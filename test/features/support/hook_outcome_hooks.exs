defmodule HookOutcomeHooks do
  use ExBdd.Hooks
  import ExUnit.Assertions

  before_scenario "@skip-by-hook", _context do
    :skipped
  end

  after_step "@step-status", context do
    assert context.step_status == :passed
    :ok
  end
end
