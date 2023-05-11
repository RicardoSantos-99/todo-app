defmodule Process.Monitor do
  def start do
    spawn(fn -> loop() end)
  end

  defp loop do
    Process.flag(:trap_exit, true)

    pid =
      spawn(fn ->
        receive do
          :erro ->
            raise "Error"

          :exit ->
            exit("Exit")

          :throw ->
            throw("Throw")
        end
      end)

    # Process.monitor(pid)
    Process.link(pid)
    Process.register(pid, :teste)
    # #
    # Process.send_after(:teste, Enum.random([:erro, :exit, :throw]), 1000)

    receive do
      message ->
        Process.sleep(3000)
        IO.inspect(message)
        loop()

        # {:EXIT, _pid, {%RuntimeError{message: _message}, _stacktrace}} ->
        #   IO.inspect("Bateu no erro")
        #   loop()

        # {:EXIT, _pid, {{:nocatch, _reason}, _stacktrace}} ->
        #   IO.inspect("Bateu no throw")
        #   loop()

        # {:EXIT, _pid, _reason} ->
        #   IO.inspect("Bateu no exit")
        #   loop()
    end
  end
end
