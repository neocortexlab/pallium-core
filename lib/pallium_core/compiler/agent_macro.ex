defmodule PalliumCore.Compiler.AgentMacro do
  defmacro construct(params, do: block) do
    quote do
      def construct(unquote(params)) do
        unquote(block)
      end
    end
  end

  defmacro run(params, do: block) do
    quote do
      def run(unquote(params)) do
        unquote(block)
      end
    end
  end
end
