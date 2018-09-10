defmodule PalliumCore.Core.TransactionTest do
  use ExUnit.Case

  alias PalliumCore.Core.Transaction

  @tx %Transaction{
    nonce: 123,
    type: :type,
    to: "to",
    from: "from",
    value: 234,
    data: ["data", "more"],
    sign: "sign"
  }

  test "encodes transaction in binary properly" do
    decoded = @tx |> Transaction.encode(:binary) |> Transaction.decode(:binary)
    assert decoded == @tx
  end

  test "encodes transaction in hex properly" do
    decoded = @tx |> Transaction.encode(:hex) |> Transaction.decode(:hex)
    assert decoded == @tx
  end

  test "encodes transaction in base64 properly" do
    decoded = @tx |> Transaction.encode(:base64) |> Transaction.decode(:base64)
    assert decoded == @tx
  end
end
