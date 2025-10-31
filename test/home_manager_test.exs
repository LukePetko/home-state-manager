defmodule HomeManagerTest do
  use ExUnit.Case
  doctest HomeManager

  test "greets the world" do
    assert HomeManager.hello() == :world
  end
end
