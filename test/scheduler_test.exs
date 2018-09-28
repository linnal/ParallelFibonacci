defmodule SchedulerTest do
  use ExUnit.Case

  test "fibonacci scheduler" do
    result = Scheduler.run(3, ParallelFibonacci, :fib, [5, 30, 20])
    expected = [{5, 5}, {20, 6765}, {30, 832_040}]

    assert result == expected
  end
end
