defmodule Ddos.Helpers.Proxy do
    def validate_proxy_list(proxys) when is_list(proxys) do
        valid_proxys = Enum.reduce(proxys, [], fn proxy, valid_proxys -> 
            IO.inspect("Validating proxy #{proxy}")
            [host, port] = String.split(proxy, ":")

            case HTTPoison.get("https://api.myip.com", [], [proxy: {:socks5, String.to_charlist(host), String.to_integer(port)}, timeout: 10_000, recv_timeout: 10_000]) do
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

        if length(valid_proxys) === 0 do
            nil
        else
            valid_proxys
        end
    end
    def validate_proxy_list(_), do: nil
end