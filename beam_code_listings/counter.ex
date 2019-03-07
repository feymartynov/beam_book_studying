defmodule Counter do
  def start_link, do: spawn_link(fn -> loop(0) end)

  def increment(counter)do
    ref = make_ref()
    counter |> send({self(), :inc, ref})

    receive do
      {^ref, count} -> count
    end
  end

  defp loop(count) do
    receive do
      {from, :inc, ref} ->
        count = count + 1
        from |> send({ref, count})
        loop(count)

      _ ->
        loop(count)
    end
  end
end

counter = Counter.start_link()
counter |> Counter.increment() |> IO.puts()
