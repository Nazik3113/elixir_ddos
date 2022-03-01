defmodule Ddos.Application do
    @moduledoc false
  
    use Application
  
    @impl true
    def start(_type, _args) do
        threads = String.to_integer(System.get_env("THREADS") || "1000")
        uries = System.get_env("URIES") || raise "environment variable SECRET_KEY_BASE is missing."
    
        IO.inspect("ddos to #{uries}")
    
        children = [
          {Task.Supervisor, name: Ddos.TaskSupervisor},
          {Ddos.Agents.DdosCache, :ddos_cache},
          {Ddos.Agents.DdosConfig, %{threads: threads, uries: String.split(uries, ",")}},
          {Ddos.GenServesr.Ddos, []}
        ]
    
        opts = [strategy: :one_for_one, name: Ddos.Supervisor]
        Supervisor.start_link(children, opts)
    end
  end