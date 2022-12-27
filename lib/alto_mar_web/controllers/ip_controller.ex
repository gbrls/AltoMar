defmodule AltoMarWeb.IPController do
  use AltoMarWeb, :controller

  def index(conn, _params) do
    ips = AltoMar.InternetAddress.list_ips()
    render(conn, :index, ips: ips)
  end

  def show(conn, %{"ip" => ip}) do
    ip_data = AltoMar.InternetAddress.get_by!(ip: ip)
    render(conn, :show, ip: ip_data)
  end
end
