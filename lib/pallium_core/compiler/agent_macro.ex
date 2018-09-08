defmodule PalliumCore.Compiler.AgentMacro do
  defmacro construct(params, do: block) do
    quote do
      def construct(unquote(params)) do
        unquote(block)
      end
    end
  end

  defmacro action(name, params, do: block) do
    quote do
      def action(unquote(to_string(name)), unquote(params)) do
        unquote(block)
      end
    end
  end

  defmacro task(name, params, do: block) do
    quote do
      def task(unquote(to_string(name)), unquote(params)) do
        unquote(block)
      end
    end
  end
end
