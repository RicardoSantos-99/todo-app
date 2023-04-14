defmodule Todo.Server do
  use GenServer

  def start(name) do
    GenServer.start(__MODULE__, name)
  end

  def add_entry(todo_server, new_entry) do
    GenServer.cast(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    GenServer.call(todo_server, {:entries, date})
  end

  @impl GenServer
  def init(name) do
    # send(self(), {:real_init, name})

    # Process.register(self(), name)

    {:ok, {name, Todo.Database.get(name) || Todo.List.new()}}
  end

  # def handle_info({:real_init, name}) do
  #   state = {name, Todo.Database.get(name) || Todo.List.new()}

  #   {:noreply, state}
  # end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, {name, todo_list}) do
    {
      :reply,
      Todo.List.entries(todo_list, date),
      {name, todo_list}
    }
  end
end
