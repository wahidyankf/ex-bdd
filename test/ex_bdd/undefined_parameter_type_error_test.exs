defmodule ExBdd.UndefinedParameterTypeErrorTest do
  use ExUnit.Case, async: true

  alias ExBdd.UndefinedParameterTypeError

  describe "new/1" do
    test "names the undefined type and has no pattern when none is given" do
      error = UndefinedParameterTypeError.new("color")

      assert %UndefinedParameterTypeError{type_name: "color", pattern: nil} = error
      assert error.message =~ "color"
    end
  end
end
