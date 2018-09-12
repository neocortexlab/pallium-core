defmodule PalliumCore.Core.Ask do
  use PalliumCore.Struct,
    device_type: :any,
    device_desc: "",
    min_memory: 0,
    same_cluster: false,
    same_node: false,
    num_devices: 1
end
