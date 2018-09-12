defmodule PalliumCore.Core.AskTest do
  use ExUnit.Case

  alias PalliumCore.Core.Ask

  test "encodes ask properly" do
    ask = %Ask{
      device_type: :gpu,
      device_desc: "GeForce GTX 1080",
      min_memory: 1024,
      same_cluster: true,
      same_node: false,
      num_devices: 1,
    }

    decoded = ask |> Ask.encode() |> Ask.decode()

    assert decoded == ask
  end
end
