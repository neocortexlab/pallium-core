defmodule PalliumCore.CryptoTest do
  use ExUnit.Case

  alias PalliumCore.Crypto

  test "encodes and decodes map" do
    map = %{a: "hello", b: "world"}
    encoded = map |> Crypto.encode_map()
    assert map == Crypto.decode_map(encoded)
  end
end
