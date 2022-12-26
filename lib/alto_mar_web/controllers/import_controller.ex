defmodule AltoMarWeb.ImportController do
  use AltoMarWeb, :controller

  def nmap_xml(conn, _params) do
    render(conn, "nmap_xml.html")
  end
end
