defmodule Kickstart.Repo.Migrations.AddIsVisibleToPricingPlans do
  use Ecto.Migration

  def change do
    alter table(:pricing_plans) do
      add :is_visible, :boolean, default: true, null: false
    end
  end
end
