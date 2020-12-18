defmodule Kickstart.Repo.Migrations.CreatePricingPlans do
  use Ecto.Migration

  def change do
    create table(:pricing_plans) do
      add :name, :string
      add :price, :decimal
      add :period, :string
      add :description, :text

      timestamps()
    end

  end
end
