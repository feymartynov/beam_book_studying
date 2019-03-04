defmodule Fib do
  def fib_tail(n) when is_integer(n) and n > 2, do: fib_tail(n, [2, 1])
  defp fib_tail(2, acc), do: Enum.reverse(acc)
  defp fib_tail(n, [b, a | _] = acc), do: fib_tail(n - 1, [a + b | acc])

  def fib_body(2), do: [1, 2]

  def fib_body(n) when is_integer(n) and n > 2 do
    prev = fib_body(n - 1)
    [a, b] = prev |> Enum.slice(-2, 2)
    prev ++ [a + b]
  end
end

defmodule Benchmark do
  @runs 10

  def run(fun) do
    Enum.reduce(1..@runs, fn _, acc -> acc + elem(:timer.tc(fun), 0) end) / @runs / 1_000_000
  end
end

n = 20_000

time_tail = Benchmark.run(fn -> Fib.fib_tail(n) end)
IO.puts("tail: #{time_tail}")

time_body = Benchmark.run(fn -> Fib.fib_body(n) end)
IO.puts("body: #{time_body}")
