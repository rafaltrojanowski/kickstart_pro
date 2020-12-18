defmodule Kickstart.Accounts.PricingPlan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pricing_plans" do
    field :description, :string
    field :name, :string
    field :period, :string
    field :price, :decimal

    timestamps()
  end

  @doc false
  def changeset(pricing_plan, attrs) do
    pricing_plan
    |> cast(attrs, [:name, :price, :period, :description])
    |> validate_required([:name, :price, :period, :description])
  end
end
