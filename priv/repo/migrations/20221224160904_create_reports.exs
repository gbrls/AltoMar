defmodule AltoMar.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :ip, :string
      add :date, :string, null: false

      timestamps()
    end

    create unique_index(:reports, [:date])

  end
end
