defmodule PalliumCore.Struct do
  defmacro __using__(fields) do
    keys = Keyword.keys(fields)

    numeric_keys =
      fields
      |> Enum.filter(fn {_, v} -> is_number(v) end)
      |> Keyword.keys()

    atomic_keys =
      fields
      |> Enum.filter(fn {_, v} -> is_atom(v) end)
      |> Keyword.keys()

    quote do
      defstruct unquote(fields)

      @encoding :binary

      def encode(%__MODULE__{} = struct) do
        unquote(keys)
        |> Enum.map(fn
          key when key in unquote(atomic_keys) -> Map.get(struct, key) |> to_string()
          key -> Map.get(struct, key)
        end)
        |> ExRLP.encode(encoding: @encoding)
      end

      def decode(rlp) do
        data =
          rlp
          |> ExRLP.decode(encoding: @encoding)
          |> Enum.zip(unquote(keys))
          |> Enum.map(fn
            {value, key} when key in unquote(numeric_keys) ->
              {key, :binary.decode_unsigned(value)}

            {value, key} when key in unquote(atomic_keys) ->
              {key, String.to_atom(value)}

            {value, key} ->
              {key, value}
          end)

        struct(__MODULE__, data)
      end
    end
  end
end
