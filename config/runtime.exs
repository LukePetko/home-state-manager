import Config

if config_env() == :dev do
  if File.exists?(".env") do
    Dotenv.load!()
  else
    IO.puts(".env file not found!")
  end
end

config :home_manager, HomeManager.Repo,
  url: System.get_env("DATABASE_URL") || raise("DATABASE_URL is not set")

config :home_manager,
  mqtt_url: System.get_env("MQTT_URL") || raise("MQTT_URL is not set")
