defmodule PalliumCore.Compiler.CompilerTest do
  use ExUnit.Case

  alias PalliumCore.Compiler

  test "compiles simple agent" do
    address = "abcdef"
    {:ok, compiled} = Compiler.compile_agent("simple", address)
    {_, agent} = Compiler.load_agent(compiled)

    assert agent.construct(1) == :ok
    assert agent.run(33) == 66
  end

  test "compiles agent with lib files" do
    address = "123456"
    {:ok, compiled} = Compiler.compile_agent("complex", address)
    {_, agent} = Compiler.load_agent(compiled)

    assert agent.run(123) == :bar
  end
end
