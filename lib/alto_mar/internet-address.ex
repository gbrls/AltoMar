defmodule AltoMar.InternetAddress do
  alias AltoMar.InternetAddress.IP
  alias AltoMar.Repo

  import Ecto.Changeset
  import Ecto

  def list_ips() do
    Repo.all(IP) |> Repo.preload(:services)
  end

  def get_by!(params) do
    IP
    |> Repo.get_by!(params)
    |> Repo.preload(:services)
  end

  def add_ip!(attrs \\ %{}) do
    {:ok, %IP{} = ip} = %IP{} |> IP.changeset(attrs) |> Repo.insert_or_update(returning: true)
    ip
  end

  def add_service(ip, attrs \\ %{}) do
    ip
    |> build_assoc(:services)
    |> cast(attrs, [:port, :name, :protocol, :product, :version, :cpe])
    |> validate_required([:port])
    |> Repo.insert()
  end
end
