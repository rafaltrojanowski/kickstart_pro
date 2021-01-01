defmodule Kickstart.Repo.Migrations.AddFeaturesToPricingPlans do
  use Ecto.Migration

  def change do
    alter table(:pricing_plans) do
      add :features, :map, on_replace: :delete
    end
  end
end
