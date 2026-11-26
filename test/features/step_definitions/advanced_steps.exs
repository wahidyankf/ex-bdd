defmodule AdvancedSteps do
  use ExBdd.StepDefinition
  import ExUnit.Assertions

  # Test step with data table in background
  step "a setup with data table", context do
    # Access datatable in different formats
    assert context.datatable.raw == [["key", "value"], ["setup", "true"]]
    assert context.datatable.headers == ["key", "value"]
    assert context.datatable.maps == [%{"key" => "setup", "value" => "true"}]

    # Pass data from the table to the next step
    Map.put(context, :setup_value, context.datatable.maps |> List.first() |> Map.get("value"))
  end

  # Test step with docstring
  step "a document with text", context do
    # Access the docstring
    assert is_binary(context.docstring)
    assert String.contains?(context.docstring, "multi-line")
    assert String.contains?(context.docstring, "formatting and indentation")

    # Store the docstring for later steps
    Map.put(context, :document, context.docstring)
  end

  # Simple step that uses data from previous step
  step "I process the document", context do
    assert context.document != nil
    assert context.setup_value == "true"

    # Transform the document
    processed_text = String.upcase(context.document)
    Map.put(context, :processed_document, processed_text)
  end

  # Verify the docstring was processed correctly
  step "I should verify it contains {string}", %{args: [search_term]} = context do
    assert context.document != nil
    assert String.contains?(context.document, search_term)
    assert String.contains?(context.processed_document, String.upcase(search_term))
    context
  end

  # Test step with data table
  step "a table of users", context do
    # Verify the data table structure
    assert length(context.datatable.maps) == 3
    assert Enum.all?(context.datatable.maps, &Map.has_key?(&1, "username"))
    assert Enum.all?(context.datatable.maps, &Map.has_key?(&1, "email"))
    assert Enum.all?(context.datatable.maps, &Map.has_key?(&1, "role"))

    # Store the users for later steps
    Map.put(context, :users, context.datatable.maps)
  end

  # Step that searches in the data from previous step
  step "I search for {string}", %{args: [search_term]} = context do
    # Find the user with the matching username
    found_user = Enum.find(context.users, &(&1["username"] == search_term))
    Map.put(context, :found_user, found_user)
  end

  # Verify the search result
  step "I should find user with email {string}", %{args: [expected_email]} = context do
    assert context.found_user != nil
    assert context.found_user["email"] == expected_email
    context
  end

  step "I write the greeting:", context do
    Map.put(context, :greeting, context.docstring)
  end

  step "the greeting is {string}", %{args: [expected]} = context do
    assert context.greeting == expected
    context
  end

  step "the guests are:", context do
    Map.put(context, :guests, context.datatable.maps)
  end

  step "the first guest is {string} in {string}", %{args: [guest, city]} = context do
    assert List.first(context.guests) == %{"guest" => guest, "city" => city}
    context
  end

  step "a guest list with a blank nickname:", context do
    Map.put(context, :blank_guests, context.datatable.maps)
  end

  step "the first nickname is {string}", %{args: [expected]} = context do
    assert List.first(context.blank_guests)["nickname"] == expected
    context
  end

  step "a table with escaped cells:", context do
    Map.put(context, :escaped, Enum.map(context.datatable.maps, &Map.get(&1, "text")))
  end

  step "the escaped cells are read", context do
    assert context.escaped == ["a | b", "line1\nline2"]
    context
  end
end
