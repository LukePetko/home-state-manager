defmodule HomeManager.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Hello from Bandit!")
  end

  get "/hello/:name" do
    send_resp(conn, 200, "Hello, #{name}!")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
