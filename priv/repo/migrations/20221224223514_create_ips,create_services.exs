defmodule :"Elixir.AltoMar.Repo.Migrations.CreateIps,createServices" do
  use Ecto.Migration

  def change do
    create table(:ips) do
      add :ip, :string, null: false
      add :raw_report, :map
      timestamps()
    end

    create unique_index(:ips, [:ip])

    create table(:services) do
      add :cpe, :string
      add :port, :integer, null: false
      add :image, :binary
      add :ip_id, references(:ips), null: false
      add :vulns, {:array, :map}
      add :report, :map

      add :name, :string
      add :protocol, :string
      add :product, :string
      add :version, :string
    end
  end
end
