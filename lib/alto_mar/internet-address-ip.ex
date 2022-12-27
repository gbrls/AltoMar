defmodule AltoMar.InternetAddress.IP do
  use Ecto.Schema
  import Ecto.Changeset
  alias AltoMar.Service

  schema "ips" do
    # TODO: Change for a better type
    field :ip, :string
    field :raw_report, :map
    has_many :services, Service
    timestamps()
  end

  def changeset(ip, attrs) do
    ip |> cast(attrs, [:ip]) |> validate_required([:ip]) |> unique_constraint(:ip)
  end
end
