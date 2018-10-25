defmodule PalliumCore.Compiler do
  @agents_dir "agents"
  @agent_module_template """
  defmodule {{module}} do
    import PalliumCore.Compiler.AgentMacro
    alias Reml.Env

    @self "{{address}}"

    {{code}}

    def start_task(agent, task), do: Env.start_task(@self, agent, task)
    def get_value(key), do: Env.get_value(@self, key)
    def set_value(key, value), do: Env.set_value(@self, key, value)
    def set_state(state), do: Env.set_state(@self, state)
  end
  """

  def compile_agent(agent_name, address) do
    with {:ok, agent_src} <- read_agent_source(agent_name) do
      agent_src
      |> agent_module(address)
      |> compile(address)
    end
  end

  defp read_agent_source(agent_name) do
    @agents_dir
    |> Path.join(agent_name <> ".agent")
    |> File.read()
  end

  defp agent_module(code, address) do
    @agent_module_template
    |> String.replace("{{module}}", address |> String.to_atom() |> inspect())
    |> String.replace("{{address}}", address)
    |> String.replace("{{code}}", code)
  end

  defp compile(module_source, address) do
    try do
      code =
        module_source
        |> Code.compile_string()
        |> cleanup()
        |> Keyword.get(String.to_atom(address))

      {:ok, code}
    rescue
      error ->
        {:error, error}
    end
  end

  defp cleanup(compiled) do
    compiled
    |> Keyword.keys()
    |> purge_modules()

    compiled
  end

  defp purge_modules([]), do: :ok

  defp purge_modules([mod | rest]) do
    :code.purge(mod)
    :code.delete(mod)
    purge_modules(rest)
  end
end
