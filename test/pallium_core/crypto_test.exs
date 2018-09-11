defmodule PalliumCore.CryptoTest do
  use ExUnit.Case

  describe "ed25519" do
    # key pair taken from tendermint priv_validator.json
    @priv_key "Wc+FEUqNnopZClE3HWV6FdRVQzJWzpVDIT1/6KBmIYLGiNeJlOZfgrBsfs11DLbUlPCGP/r1gFTM13H0+r31JQ==" |> Base.decode64!()
    @pub_key "xojXiZTmX4KwbH7NdQy21JTwhj/69YBUzNdx9Pq99SU=" |> Base.decode64!()

    test "validates a message signed with tendermint keys" do
      msg = "Yellow submarine"
      sig = Ed25519.signature(msg, @priv_key, @pub_key)
      assert Ed25519.valid_signature?(sig, msg, @pub_key)
    end

    test "derives tendermint pub key from its priv key" do
      derived = Ed25519.derive_public_key(@priv_key)
      assert @pub_key == derived
    end
  end
end
