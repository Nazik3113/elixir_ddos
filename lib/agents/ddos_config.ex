defmodule Ddos.Agents.DdosConfig do
    use Agent
    alias Ddos.Helpers.Proxy
    alias Ddos.Helpers.Env

    def start_link(nil) do
        threads = Env.get_threads_from_env()
        urls = Env.get_urls_from_env()
        proxys = Env.get_proxys_from_env()

        IO.inspect("ddos to #{inspect(urls)}")

        active_proxys = Proxy.validate_proxy_list(proxys)

        conf = %{threads: threads, urls: urls, proxys: active_proxys}

        Agent.start_link(fn -> 
                if length(active_proxys) === 0 do
                    Map.put(conf, :use_proxy, false)
                else
                    Map.put(conf, :use_proxy, true)
                end
            end, 
            name: __MODULE__
        )
    end
    
    def get_threads() do
        Agent.get(__MODULE__, fn %{threads: threads} -> threads end)
    end

    def get_urls() do
        Agent.get(__MODULE__, fn %{urls: urls} -> urls end)
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