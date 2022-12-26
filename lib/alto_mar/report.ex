
defmodule AltoMar.Report do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reports" do
    field :ip, :string
    field :date, :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:ip, :date])
    |> validate_required([:ip, :date])
    |> validate_length(:ip, min: 4 + 3, max: 3 * 4 + 3)
  end
end
