defmodule ByteCodeCompiler do
  @stop 0
  @add 1
  @multiply 2
  @push 3

  def compile(code) do
    {:ok, tokens, _} = code |> Kernel.<>(".") |> String.to_charlist() |> :erl_scan.string()
    {:ok, [parse_tree]} = tokens |> :erl_parse.parse_exprs()
    generate(parse_tree) ++ [@stop]
  end

  defp generate({:op, _line, :+, x, y}), do: generate(x) ++ generate(y) ++ [@add]
  defp generate({:op, _line, :*, x, y}), do: generate(x) ++ generate(y) ++ [@multiply]
  defp generate({:integer, _line, value}), do: [@push, integer(value)]

  defp integer(value) do
    l = value |> :binary.encode_unsigned() |> :erlang.binary_to_list()
    [length(l) | l]
  end
end

{[output: output_path], [input_path | _]} =
  System.argv()
  |> OptionParser.parse!(aliases: [o: :output], strict: [output: :string])

byte_code = input_path |> File.read!() |> ByteCodeCompiler.compile()
File.write!(output_path, byte_code)
