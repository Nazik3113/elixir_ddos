defmodule Ddos.Helpers.Proxy do
    @moduledoc false

    def validate_proxy_list(proxys) when is_list(proxys) do
        Enum.reduce(proxys, [], fn proxy, valid_proxys -> 
            IO.inspect("Validating proxy #{proxy}")
            [host, port] = String.split(proxy, ":")

            case HTTPoison.get("https://api.myip.com", [], [proxy: {:socks5, String.to_charlist(host), String.to_integer(port)}, timeout: 5_000, recv_timeout: 5_000]) do
                {:ok, %HTTPoison.Response{body: body}} -> 
                    with {:ok, body_map} = Jason.decode(body),
                         "" <> ip = Map.get(body_map, "ip")
                    do
                        if ip == host do
                            IO.inspect("Proxy: #{proxy} is valid") 
                            [{String.to_charlist(host), String.to_integer(port)} | valid_proxys]                         
                        else
                            IO.inspect("Proxy: #{proxy} is invalid") 
                            valid_proxys  
                        end
                    else
                        _ -> 
                            IO.inspect("Proxy: #{proxy} is invalid") 
                            valid_proxys  
                    end     
                _response ->
                    IO.inspect("Proxy: #{proxy} is invalid") 
                    valid_proxys  
            end
        end)
    end
    def validate_proxy_list(_), do: []
end