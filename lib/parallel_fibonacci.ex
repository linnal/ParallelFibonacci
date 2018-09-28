alias Scheduler

defmodule ParallelFibonacci do
  def fib(scheduler) do
    send(scheduler, {:ready, self()})

    receive do
      {:fib, n, client} ->
        send(client, {:answer, n, fib_calc(n), self()})
        fib(scheduler)

      {:shutdown} ->
        exit(:normal)
    end
  end

  defp fib_calc(n) do
    _fib_calc(n, 1, [1, 0])
  end
 
  defp _fib_calc(n, m, mem) when n == m+1 do
    Enum.sum(mem)
  end

  defp _fib_calc(n, m, mem) do
    next = Enum.sum(mem)
    [prev, _] = mem
    _fib_calc(n, m+1, [next, prev])
  end
end

