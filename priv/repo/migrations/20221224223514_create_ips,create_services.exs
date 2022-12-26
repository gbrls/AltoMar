defmodule :"Elixir.AltoMar.Repo.Migrations.CreateIps,createServices" do
  use Ecto.Migration

  def change do
    create table(:ips) do
      add :ip, :string
      add :last_report, :map 
      timestamps()
    end

    create table(:services) do
      add :cpe, :string
      add :port, :decimal
      add :ip, references(:ips)
      add :vulns, {:array, :string}
    end

    create unique_index(:services, [:ip])
  end
end
