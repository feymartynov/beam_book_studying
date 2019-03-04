defmodule StackMachine do
  def compile(code) do
    {:ok, tokens, _} = code |> Kernel.<>(".") |> String.to_charlist() |> :erl_scan.string()
    {:ok, [parse_tree]} = tokens |> :erl_parse.parse_exprs()
    generate(parse_tree)
  end

  defp generate({:op, _line, :+, x, y}), do: generate(x) ++ generate(y) ++ [:add]
  defp generate({:op, _line, :*, x, y}), do: generate(x) ++ generate(y) ++ [:multiply]
  defp generate({:integer, _line, value}), do: [:push, value]

  def interpret(code), do: interpret(code, [])
  defp interpret([:push, value | rest], stack), do: interpret(rest, [value | stack])
  defp interpret([:add | rest], [y, x | stack]), do: interpret(rest, [x + y | stack])
  defp interpret([:multiply | rest], [y, x | stack]), do: interpret(rest, [x * y | stack])
  defp interpret([], [result | _]), do: result
end

"8 + 17 * 2"
|> StackMachine.compile()
|> StackMachine.interpret()
|> IO.puts()
