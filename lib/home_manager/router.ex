defmodule HomeManager.Router do
  use Plug.Router

  alias HomeManager.Routes.ApiRouter

  plug :match
  plug :dispatch

  get "/" do
    url = Application.get_env(:home_manager, HomeManager.Repo)[:url]
    send_resp(conn, 200, "Hello from Bandit! #{url}")
  end

  get "/hello/:name" do
    send_resp(conn, 200, "Hello, #{name}!")
  end

  forward "/api", to: ApiRouter

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
