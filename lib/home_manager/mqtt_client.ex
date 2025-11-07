defmodule HomeManager.MqttClient do
  use Tortoise.Handler

  @client_id "home_manager_#{System.get_env("HOSTNAME") || "default"}"

  alias HomeManager.Mqtt.Router

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def start_link(_opts \\ []) do
    mqtt_url = Application.get_env(:home_manager, :mqtt_url)
    IO.puts("Starting MQTT client with URL #{mqtt_url}")

    Tortoise.Supervisor.start_child(
      client_id: @client_id,
      handler: {__MODULE__, []},
      server: parse_mqtt_url(mqtt_url),
      subscriptions: [
        {"home/set/global/state", 0},
        {"home/set/room/+/state", 0}
      ]
    )
  end

  defp parse_mqtt_url(url) when is_binary(url) do
    uri = URI.parse(url)

    transport =
      case uri.scheme do
        "mqtt" -> Tortoise.Transport.Tcp
        "mqtts" -> Tortoise.Transport.SSL
        "ssl" -> Tortoise.Transport.SSL
        _ -> Tortoise.Transport.Tcp
      end

    port = uri.port || 1883

    {transport, host: uri.host, port: port}
  end

  def handle_message(topic, payload, _opts) do
    Router.route(topic, payload)
    {:ok, payload}
  end

  def publish(topic, payload, opts \\ []) do
    Tortoise.publish(@client_id, topic, payload, opts)
    {:ok, payload}
  end
end
