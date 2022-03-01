defmodule Ddos.Agents.DdosConfig do
    use Agent

    def start_link(%{threads: threads, uries: uries} = config) do
        Agent.start_link(fn -> config end, name: __MODULE__)
    end
    
    def get_threads() do
        Agent.get(__MODULE__, fn %{threads: threads} -> threads end)
    end

    def get_uries() do
        Agent.get(__MODULE__, fn %{uries: uries} -> uries end)
    end
end