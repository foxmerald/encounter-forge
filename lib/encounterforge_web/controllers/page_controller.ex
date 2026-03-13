defmodule EncounterforgeWeb.PageController do
  use EncounterforgeWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
