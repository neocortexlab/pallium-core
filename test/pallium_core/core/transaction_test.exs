defmodule PalliumCore.Core.TransactionTest do
  use ExUnit.Case

  alias PalliumCore.Core.Transaction

  test "encodes transaction properly" do
    tx = %Transaction{
      nonce: 123,
      type: :type,
      to: "to",
      from: "from",
      value: 234,
      data: "data",
      sign: "sign"
    }

    decoded = tx |> Transaction.encode() |> Transaction.decode()

    assert decoded == tx
  end
end
