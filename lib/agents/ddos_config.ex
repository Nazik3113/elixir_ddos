defmodule Ddos.Agents.DdosConfig do
    use Agent
    alias Ddos.Helpers.Proxy
    alias Ddos.Helpers.Env

    def start_link(nil) do
        threads = Env.get_threads_from_env()
        uries = Env.get_uries_from_env()
        proxys = Env.get_proxys_from_env()

        IO.inspect("ddos to #{inspect(uries)}")

        active_proxys = Proxy.validate_proxy_list(proxys)

        if length(active_proxys) === 0 do
            Agent.start_link(fn -> %{threads: threads, uries: uries, proxys: active_proxys, use_proxy: false} end, name: __MODULE__)            
        else
            Agent.start_link(fn -> %{threads: threads, uries: uries, proxys: active_proxys, use_proxy: true} end, name: __MODULE__)            
        end
    end
    
    def get_threads() do
        Agent.get(__MODULE__, fn %{threads: threads} -> threads end)
    end

    def get_uries() do
        Agent.get(__MODULE__, fn %{uries: uries} -> uries end)
    end

    def get_random_proxy do
        Agent.get(__MODULE__, fn %{proxys: proxys} ->
            if length(proxys) > 0 do
                Enum.random(proxys) 
            else
                {nil, nil}
            end
        end)
    end

    def get_use_proxy do
        Agent.get(__MODULE__, fn %{use_proxy: use_proxy} -> use_proxy end)
    end
end