defmodule AltoMar.CVE do
  alias AltoMar.Service
  use Ecto.Schema

  schema "cves" do
    field :cpe, :string
    field :cvss, :float
    field :cve, :string
    belongs_to :service, Service 
  end
end
