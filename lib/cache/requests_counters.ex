defmodule Ddos.Cache.RequestsCache do
    alias Ddos.Agents.DdosCache

    def increment_requests_counter do
        table_name = DdosCache.get_table()
        requests = :ets.update_counter(table_name, :requests, 1)
        {:success_requests, success_requests} = :ets.lookup(table_name, :success_requests) |> List.first
        IO.inspect("Requests: #{requests}, requests with success: #{success_requests}")
    end

    def increment_success_requests_counter do
        table_name = DdosCache.get_table()
        requests = :ets.update_counter(table_name, :requests, 1)
        success_requests = :ets.update_counter(table_name, :success_requests, 1)
        IO.inspect("Requests: #{requests}, requests with success: #{success_requests}")
    end
end