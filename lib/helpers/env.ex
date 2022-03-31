defmodule Ddos.Helpers.Env do
    @moduledoc false 
    
    def get_urls_from_env do
        urls = System.get_env("URLS") || raise "environment variable URLS is missing."
        String.split(urls, ",")
    end

    def get_proxys_from_env do
        proxys = System.get_env("PROXYS") || nil

        if proxys !== nil && byte_size(proxys) > 0 do
          String.split(proxys, ",")
        else
          []
        end
    end

    def get_threads_from_env do
        String.to_integer(System.get_env("THREADS") || "500")
    end
end