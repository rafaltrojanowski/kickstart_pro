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
    |> cast_embed(:features, with: &Kickstart.Accounts.Feature.changeset/2, required: true)
  end
end

defmodule Kickstart.Accounts.Feature do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :title
    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true
  end

  def changeset(feature, attrs) do
    feature
    # So its persisted
    |> Map.put(:temp_id, feature.temp_id || attrs["temp_id"])
    # Add delete here
    |> cast(attrs, [:title, :delete])
    |> validate_required([:title])
    |> maybe_mark_for_deletion()
  end

  defp maybe_mark_for_deletion(%{data: %{id: nil}} = changeset), do: changeset

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
