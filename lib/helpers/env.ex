defmodule Ddos.Helpers.Env do
    @moduledoc false 
    
    def get_uries_from_env do
        uries = System.get_env("URIES") || raise "environment variable URIES is missing."
        String.split(uries, ",")
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