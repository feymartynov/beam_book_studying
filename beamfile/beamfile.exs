defmodule Beamfile do
  defmodule Function do
    defstruct [:name, :arity, :label]
  end

  defmodule Code do
    defstruct [
      :instruction_set_version,
      :opcode_max,
      :label_count,
      :function_count,
      :instructions
    ]
  end

  def read(filename) do
    <<"FOR1", _size::size(32)-big, "BEAM", chunks::binary>> = File.read!(filename)
    chunks |> read_chunks([]) |> Enum.map(&parse_chunk/1)
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

  defp parse_chunk({"AtU8", _size, <<_atoms_count::size(32)-big, atoms::binary>>}) do
    parsed_atoms = for <<len, name::size(len)-binary <- atoms>>, len > 0, do: String.to_atom(name)
    {:atoms, parsed_atoms}
  end

  defp parse_chunk({"ExpT", _size, <<_exports_count::size(32)-big, exports::binary>>}) do
    parsed_exports =
      for <<name::size(32)-big, arity::size(32)-big, label::size(32)-big <- exports>> do
        %Function{name: name, arity: arity, label: label}
      end

    {:exports, parsed_exports}
  end

  defp parse_chunk({"ImpT", _size, <<_imports_count::size(32)-big, imports::binary>>}) do
    parsed_imports =
      for <<name::size(32)-big, arity::size(32)-big, label::size(32)-big <- imports>> do
        %Function{name: name, arity: arity, label: label}
      end

    {:imports, parsed_imports}
  end

  defp parse_chunk(
         {"Code", _size,
          <<_sub_size::size(32)-big, instruction_set_version::size(32)-big,
            opcode_max::size(32)-big, label_count::size(32)-big, function_count::size(32)-big,
            instructions::binary>>}
       ) do
    parsed_code = %Code{
      instruction_set_version: instruction_set_version,
      opcode_max: opcode_max,
      label_count: label_count,
      function_count: function_count,
      instructions: instructions
    }

    {:code, parsed_code}
  end

  defp parse_chunk({"StrT", _size, strings}) do
    {:strings, :erlang.binary_to_list(strings)}
  end

  defp parse_chunk({"Attr", size, data}) do
    <<attrs::size(size)-binary, _pad::binary>> = data
    {:attributes, :erlang.binary_to_term(attrs)}
  end

  defp parse_chunk({"CInf", size, data}) do
    <<compile_info::size(size)-binary, _pad::binary>> = data
    {:compile_info, :erlang.binary_to_term(compile_info)}
  end

  defp parse_chunk({"LocT", _size, <<_functions_count::size(32)-big, functions::binary>>}) do
    parsed_functions =
      for <<name::size(32)-big, arity::size(32)-big, label::size(32)-big <- functions>> do
        %Function{name: name, arity: arity, label: label}
      end

    {:local_functions, parsed_functions}
  end

  defp parse_chunk({"LitT", _size, <<_uncompr_size::size(32)-big, literals::binary>>}) do
    parsed_literals =
      for <<size::size(32)-big, literal::size(size)-binary <- literals>> do
        :erlang.binary_to_term(literal)
      end

    {:literals, parsed_literals}
  end

  defp parse_chunk({"Abst", _size, abstract_code}) do
    {:abstract_code, :erlang.binary_to_term(abstract_code)}
  end

  defp parse_chunk({chunk_name, _size, _content}) do
    {:not_implemented_chunk, chunk_name}
  end
end

# elxiir ./beamfile.exs ./example.beam
System.argv() |> List.first() |> Beamfile.read() |> IO.inspect()
