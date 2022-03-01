defmodule DdosTest do
  use ExUnit.Case
  doctest Ddos

  test "greets the world" do
    assert Ddos.hello() == :world
  end
end
