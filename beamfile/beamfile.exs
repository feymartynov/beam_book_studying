defmodule Beamfile do
  def read(filename) do
    <<"FOR1", size::size(32)-big, "BEAM", chunks::binary>> = File.read!(filename)
    {size, chunks |> read_chunks([]) |> Enum.map(&parse_chunk/1)}
  end

  defp read_chunks(<<n, a, m, e, size::size(32)-big, tail::binary>>, acc) do
    chunk_length = align_by_four(size)
    <<chunk::size(chunk_length)-binary, rest::binary>> = tail
    read_chunks(rest, [{List.to_string([n, a, m, e]), size, chunk} | acc])
  end

  defp read_chunks(<<>>, acc) do
    Enum.reverse(acc)
  end

  defp align_by_four(n) do
    4 * div(n + 3, 4)
  end

  defp parse_chunk({"AtU8", _size, <<_number_of_atoms::size(32)-big, atoms::binary>>}) do
    parsed_atoms = for <<len, name::size(len)-binary <- atoms >>, len > 0, do: String.to_atom(name)
    {:atoms, parsed_atoms}
  end

  defp parse_chunk({chunk_name, _size, _content}) do
    {:not_implemented_chunk, chunk_name}
  end
end

# elxiir ./beamfile.exs ./example.beam
{size, chunks} = System.argv() |> List.first() |> Beamfile.read()
IO.puts("Size: #{size}")
IO.inspect(chunks)
