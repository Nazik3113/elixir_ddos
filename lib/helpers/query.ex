defmodule Ddos.Helpers.Query do
    @moduledoc false

    def request(url, false, _host, _port) do
        HTTPoison.get(url, [], [ssl: [verify: :verify_none], hackney: [pool: :ddos], timeout: 5_000, recv_timeout: 5_000])
    end

    def request(url, true, host, port) do
        HTTPoison.get(url, [], [ssl: [verify: :verify_none], hackney: [pool: :ddos], proxy: {:socks5, host, port}, timeout: 5_000, recv_timeout: 5_000])
    end
end