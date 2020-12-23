defmodule Kickstart.Repo.Migrations.AddPositionToPricingPlans do
  use Ecto.Migration

  def change do
    alter table(:pricing_plans) do
      add :position, :integer, default: 0, null: false
    end
  end
end
