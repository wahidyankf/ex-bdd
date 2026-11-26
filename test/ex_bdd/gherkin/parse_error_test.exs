defmodule ExBdd.Gherkin.ParseErrorTest do
  use ExUnit.Case, async: true

  alias ExBdd.Gherkin.ParseError

  describe "message/1" do
    test "locates an error without a file by line and column" do
      error = %ParseError{message: "a step", line: 3, column: 5, rest: nil, file: nil}

      assert ParseError.message(error) =~ "Gherkin parse error at line 3, column 5:"
    end

    test "locates an error with a file by path, line, and column" do
      error = %ParseError{message: "a step", line: 3, column: 5, rest: nil, file: "a.feature"}

      assert ParseError.message(error) =~ "Gherkin parse error at a.feature:3:5:"
    end
  end
end
