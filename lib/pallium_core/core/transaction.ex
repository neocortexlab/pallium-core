defmodule PalliumCore.Core.Transaction do
  use PalliumCore.Struct,
    nonce: 0,
    type: :none,
    to: "",
    from: "",
    value: 0,
    data: "",
    sign: ""
end
