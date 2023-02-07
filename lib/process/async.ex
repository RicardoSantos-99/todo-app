defmodule Process.Async do
  def run_query(query_def) do
    Process.sleep(2000)
    "#{query_def} result"
  end

  def async_query(query_def) do
    spawn(fn -> IO.puts(run_query(query_def)) end)
  end

  def async() do
    fn query_def ->
      caller = self()

      spawn(fn ->
        send(caller, {:query_result, run_query(query_def)})
      end)
    end
  end

  def create_process() do
    Enum.each(1..5, &async_query("query #{&1}"))
  end

  def get_result() do
    fn ->
      receive do
        {:query_result, result} -> result
      end
    end
  end
end
