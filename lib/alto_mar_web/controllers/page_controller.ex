defmodule AltoMarWeb.PageController do
  use AltoMarWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
