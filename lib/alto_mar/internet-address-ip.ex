defmodule AltoMar.InternetAddress.IP do
  use Ecto.Schema
  import Ecto.Changeset
  alias AltoMar.Service

  schema "ips" do
    field :ip, :string # TODO: Change for a better type
    has_many :services, Service
    field :last_report, :map 
    timestamps()
  end
end

defmodule AltoMar.InternetAddress do


  def import_report() do
    
  end
end
