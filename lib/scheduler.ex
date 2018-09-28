defmodule Scheduler do
  def run(num_processes, module_name, func_name, to_calculate) do
    1..num_processes
    # list of pids that execute ParallelFibonacci
    |> Enum.map(fn _ -> spawn(module_name, func_name, [self()]) end)
    |> schedule_processes(to_calculate, [])
  end

  defp schedule_processes(pids, queue, results) do
    receive do
      {:ready, pid} when queue != [] ->
        [head | tail] = queue
        send(pid, {:fib, head, self()})
        schedule_processes(pids, tail, results)

      {:ready, pid} ->
        send(pid, {:shutdown})
        # shutdown all the other pids
        if length(pids) > 1 do
          schedule_processes(List.delete(pids, pid), queue, results)
        else
          Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end)
        end

      {:answer, number, result, _pid} ->
        schedule_processes(pids, queue, [{number, result} | results])
    end
  end
end
