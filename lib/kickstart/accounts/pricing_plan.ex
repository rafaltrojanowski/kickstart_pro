defmodule Kickstart.Accounts.PricingPlan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pricing_plans" do
    field :description, :string
    field :name, :string
    field :period, :string
    field :price, :decimal
    field :position, :integer
    field :is_visible, :boolean

    timestamps()
  end

  @doc false
  def changeset(pricing_plan, attrs) do
    pricing_plan
    |> cast(attrs, [:name, :price, :period, :description, :position, :is_visible])
    |> validate_required([:name, :price, :period, :description, :position])
    |> validate_length(:description, min: 5)
    |> validate_number(:price, greater_than: 0)
  end
end
