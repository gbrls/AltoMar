defmodule AltoMar.InternetAddress do
  alias AltoMar.InternetAddress.IP
  alias AltoMar.Repo

  def list_ips() do
    Repo.all(IP)
  end

  def add_ip(attrs \\ %{}) do
    %IP{} |> IP.changeset(attrs) |> Repo.insert()
  end
end
