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

  def load_agent(modules) do
    modules
    |> Enum.map(fn [name, code] -> :code.load_binary(String.to_atom(name), 'nofile', code) end)
    |> Enum.at(0)
  end


  def load_agent_modules([]), do: :ok
  def load_agent_modules([[mod, binary] | rest]) do
    case :code.load_binary(String.to_atom(mod), 'nofile', binary) do
      {:module, _} -> load_agent_modules(rest)
      {:error, reason} -> {:error, reason}
    end
  end

  def compile_agent(agent_name, address) do
    try do
      {agent_file, lib_files} = discover_agent_files(agent_name)
      {:ok, compile_agent_file(agent_file, address) ++ compile_files(lib_files, address)}
    rescue
      error ->
        {:error, error}
    end
  end

  defp discover_agent_files(agent_name) do
    path = Path.join(@agents_dir, agent_name)
    case File.dir?(path) do
      true -> {Path.join(path, agent_name <> ".agent"), Path.wildcard(path <> "/lib/**/*.ex")}
      false -> {path <> ".agent", []}
    end
  end

  defp compile_files(files, _namespace) do
    files
    |> Enum.map(&Code.compile_file/1)
    |> List.flatten()
    |> cleanup()
  end

  defp compile_agent_file(agent_file, address) do
    agent_file
    |> File.read!()
    |> construct_module(address)
    |> Code.compile_string()
    |> cleanup()
  end

  defp construct_module(code, address) do
    @agent_module_template
    |> String.replace("{{module}}", address |> String.to_atom() |> inspect())
    |> String.replace("{{address}}", address)
    |> String.replace("{{code}}", code)
  end

  defp cleanup(compiled) do
    compiled
    |> Keyword.keys()
    |> purge_modules()

    compiled
    |> Enum.map(fn {mod, code} -> [Atom.to_string(mod), code] end)
  end

  defp purge_modules([]), do: :ok

  defp purge_modules([mod | rest]) do
    :code.purge(mod)
    :code.delete(mod)
    purge_modules(rest)
  end
end
