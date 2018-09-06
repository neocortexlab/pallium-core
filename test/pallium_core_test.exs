defmodule PalliumCoreTest do
  use ExUnit.Case
  doctest PalliumCore

  test "greets the world" do
    assert PalliumCore.hello() == :world
  end
end
