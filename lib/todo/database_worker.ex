defmodule Todo.DatabaseWorker do
  use GenServer

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder)
  end

  def store(worker_pid, key, data) do
    GenServer.cast(worker_pid, {:store, key, data})
  end

  def get(worker_pid, key) do
    GenServer.call(worker_pid, {:get, key})
  end

  @impl GenServer
  def init(db_folder) do
    {:ok, db_folder}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, db_folder) do
    db_folder
    |> file_name(key)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, db_folder}
  end

  @impl GenServer
  def handle_call({:get, key}, _, db_folder) do
    data =
      case File.read(file_name(db_folder, key)) do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        _ -> nil
      end

    {:reply, data, db_folder}
  end

  defp file_name(db_folder, key) do
    Path.join(db_folder, to_string(key))
  end
end

#  {:ok, cache} = Todo.Cache.start()
#   bobs_list = Todo.Cache.server_process(cache, "bobs_list")
#  ricardo_list = Todo.Cache.server_process(cache, "ricardo_list")
#  Todo.Server.add_entry(bobs_list, %{date: ~D[2018-12-19], title: "Dentist"})
#   Todo.Server.entries(bobs_list, ~D[2018-12-19])
#   Todo.Server.entries(ricardo_list, ~D[2018-12-20])
