defmodule AltoMar.Service do
  alias AltoMar.InternetAddress.IP
  alias AltoMar.CVE

  use Ecto.Schema
  import Ecto.Changeset

  schema "services" do
    field :port, :decimal
    has_many :vulns, CVE
    belongs_to :ip, IP
  end

  def changeset(service, attrs) do
    service |> cast(attrs, [:ip, :port, :vulns]) |> validate_required([:ip, :port])
  end
end
