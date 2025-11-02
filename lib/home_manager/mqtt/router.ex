defmodule HomeManager.Mqtt.Router do
  @moduledoc false

  alias HomeManager.Mqtt.Handlers.{HomeState}

  def route(topic, payload) do
    do_route(topic, payload)
  end

  defp do_route(["home", "set", "global", "state"], payload) do
    HomeState.handle(payload)
  end

  defp do_route(topic, _) do
    IO.puts("No handler found for topic #{inspect(topic)}")
  end
end
