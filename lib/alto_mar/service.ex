defmodule AltoMar.Service do
  alias AltoMar.InternetAddress.IP
  alias AltoMar.CVE

  use Ecto.Schema
  import Ecto.Changeset

  schema "services" do
    field :port, :integer
    field :cpe, :string
    field :image, :binary

    field :name, :string
    field :protocol, :string
    field :product, :string
    field :version, :string
    # has_many :vulns, CVE
    field :vulns, {:array, :map}
    belongs_to :ip, IP
    field :report, :map
  end

  def changeset(service, attrs) do
    service |> cast(attrs, [:ip, :port]) |> validate_required([:ip, :port])
  end
end
