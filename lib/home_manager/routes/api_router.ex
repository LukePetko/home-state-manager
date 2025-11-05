defmodule HomeManager.Routes.ApiRouter do
  use Plug.Router

  alias HomeManager.Routes.{GlobalState, RoomState}

  plug :match
  plug :dispatch

  forward "/global/state", to: GlobalState
  forward "/room/state", to: RoomState
end
