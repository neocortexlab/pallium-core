defmodule PalliumCore.Crypto do
  def hash(data), do: :crypto.hash(:sha256, data)

  def from_hex(hex_data), do: Base.decode16!(hex_data, case: :lower)

  def to_hex(bin), do: Base.encode16(bin, case: :lower)

  def gen_key_pair() do
    {_secret_key, _public_key} = Ed25519.generate_key_pair()
  end

  def gen_address(public_key), do: public_key |> hash()

  def encode_map(%{} = map) do
    map
    |> Enum.map(fn
      {k, v} when is_atom(k) and is_binary(v) ->
        [k, v]
        |> Enum.map(&(&1 |> to_string() |> to_hex()))
        |> Enum.join("=")

      _ ->
        raise "Encode map only with atom keys and binary values (or implement other cases)"
        # "#{to_hex(to_string(k))}=#{to_hex(to_string(v))}"
    end)
    |> Enum.join(",")
  end

  def decode_map(string) do
    string
    |> String.split(",")
    |> Enum.reject(&(&1 == ""))
    |> Map.new(fn pair_str ->
      [k, v] =
        pair_str
        |> String.split("=")
        |> Enum.map(&from_hex/1)

      {String.to_atom(k), v}
    end)
  end
end
