defmodule Todo.Metrics do
  use Task

  def start_link(_), do: Task.start_link(&loop/0)

  defp loop do
    Process.sleep(:timer.seconds(10))
    IO.inspect(collect_metric())
    loop()
  end

  defp collect_metric() do
    [
      memory_usage: :erlang.memory(:total),
      process_count: :erlang.system_info(:process_count)
    ]
  end
end
