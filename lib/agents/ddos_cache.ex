defmodule Ddos.Agents.DdosCache do

    use Agent

    def start_link(table_name) do
        Agent.start_link(fn ->
            table_name = :ets.new(
                table_name, 
                [
                    :set, 
                    :public,
                    :named_table,
                    read_concurrency: true,
                    write_concurrency: true
                ]
            )
            :ets.insert(table_name, {:requests, 0})
            :ets.insert(table_name, {:success_requests, 0})

            table_name
        end, name: __MODULE__)
    end

    def get_table do
        Agent.get(__MODULE__, fn table_name -> table_name end)
    end
end