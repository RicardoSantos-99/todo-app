defmodule Todo.TodoCacheTest do
  use ExUnit.Case

  test "server_process" do
    bob_pid = Todo.Cache.server_process(cache, "bob")

    assert bob_pid != Todo.Cache.server_process(cache, "alice")
    assert bob_pid == Todo.Cache.server_process(cache, "bob")
  end

  test "to-do operations" do
    alice = Todo.Cache.server_process(cache, "alice")
    Todo.Server.add_entry(alice, %{date: ~D[2018-01-01], title: "Dentist"})
    entries = Todo.Server.entries(alice, ~D[2018-01-01])

    assert [%{date: ~D[2018-01-01], title: "Dentist"}] = entries
  end
end
