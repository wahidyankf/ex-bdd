defmodule HookOutcomeSteps do
  use ExBdd.StepDefinition

  step "a step that must not run", _context do
    raise "a step ran after its scenario was skipped"
  end

  step "a step that skips the rest of its scenario", _context do
    :skipped
  end

  step "a passing step", context do
    context
  end
end
