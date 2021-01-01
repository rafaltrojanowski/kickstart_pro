defmodule Kickstart.Accounts.PricingPlan do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kickstart.Accounts.Feature

  schema "pricing_plans" do
    field :description, :string
    field :name, :string
    field :period, :string
    field :price, :decimal
    field :position, :integer
    field :is_visible, :boolean

    embeds_many :features, Feature, on_replace: :delete
    timestamps()
  end

  @doc false
  def changeset(pricing_plan, attrs) do
    pricing_plan
    |> cast(attrs, [:name, :price, :period, :description, :position, :is_visible])
    |> validate_required([:name, :price, :period, :description, :position])
    |> validate_length(:description, min: 5)
    |> validate_number(:price, greater_than: 0)
    |> cast_embed(:features, with: &feature_changeset/2, required: true)
  end

  defp feature_changeset(schema, params) do
    schema
    |> cast(params, [:title])
  end
end

defmodule Kickstart.Accounts.Feature do
  use Ecto.Schema

  embedded_schema do
    field :title
  end
end
