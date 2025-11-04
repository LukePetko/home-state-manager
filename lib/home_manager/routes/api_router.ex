defmodule HomeManager.Routes.ApiRouter do
  use Plug.Router

  alias HomeManager.Routes.{GlobalState}

  plug :match
  plug :dispatch

  forward "/global/state", to: GlobalState
end
