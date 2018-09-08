defmodule PalliumCore.Compiler.CompilerTest do
  use ExUnit.Case

  alias PalliumCore.Compiler

  test "compiles" do
    address = "abcdef"
    {:ok, code} = Compiler.compile_agent("test", address)
    {:module, agent} = :code.load_binary(String.to_atom(address), 'nofile', code)

    assert agent.construct(1) == :ok
    assert agent.action("run", 33) == 66
    assert agent.task("learn", 3) == 9
  end
end
