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

      @default_encoding :binary

      def encode(%__MODULE__{} = struct, encoding \\ @default_encoding) do
        unquote(keys)
        |> Enum.map(fn
          key when key in unquote(atomic_keys) ->
            Map.fetch!(struct, key)
            |> to_string()

          key ->
            Map.fetch!(struct, key)
        end)
        |> ExRLP.encode(encoding: encoding)
      end

      def decode(rlp, encoding \\ @default_encoding) do
        data =
          rlp
          |> ExRLP.decode(encoding: encoding)
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
