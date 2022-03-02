defmodule Ddos.Application do
    @moduledoc false
  
    use Application
  
    @impl true
    def start(_type, _args) do    
        children = [
          {Task.Supervisor, name: Ddos.TaskSupervisor},
          {Ddos.Agents.DdosCache, :ddos_cache},
          {Ddos.Agents.DdosConfig, nil},
          {Ddos.GenServesr.Ddos, []}
        ]
    
        opts = [strategy: :one_for_one, name: Ddos.Supervisor]
        Supervisor.start_link(children, opts)
    end
  end