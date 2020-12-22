defmodule Kickstart.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :start_at, :naive_datetime
      add :end_at, :naive_datetime
      add :status, :string
      add :payment_response, :map
      add :user_id, references(:users, on_delete: :nothing)
      add :pricing_plan_id, references(:pricing_plans, on_delete: :nothing)

      timestamps()
    end

    create index(:subscriptions, [:user_id])
    create index(:subscriptions, [:pricing_plan_id])
  end
end
