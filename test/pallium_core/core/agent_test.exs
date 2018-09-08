defmodule PalliumCore.Core.AgentTest do
  use ExUnit.Case

  alias PalliumCore.Core.Agent

  test "encodes agent properly" do
    agent = %Agent{
      nonce: 123,
      balance: 22,
      state: "state",
      code: "code",
      key: "key"
    }

    decoded = agent |> Agent.encode() |> Agent.decode()

    assert decoded == agent
  end
end
