defmodule Add do
  def add(x, y), do: id(x) + id(y)

  defp id(i), do: i
end
