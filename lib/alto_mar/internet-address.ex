defmodule AltoMar.Service do
  alias AltoMar.InternetAddress.IP
  use Ecto.Schema

  schema "services" do
    field :cpe, :string
    field :port, :decimal
    field :vulns, {:array, :string}
    belongs_to :ip, IP
  end
end
