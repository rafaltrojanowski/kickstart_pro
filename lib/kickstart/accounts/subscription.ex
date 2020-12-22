defmodule Kickstart.Accounts.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscriptions" do
    field :end_at, :naive_datetime
    field :payment_response, :map
    field :start_at, :naive_datetime
    field :status, :string

    belongs_to :user, Kickstart.Accounts.User
    belongs_to :pricing_plan, Kickstart.Accounts.PricingPlan

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:start_at, :end_at, :status, :payment_response])
    |> validate_required([:start_at, :end_at, :status, :payment_response])
  end
end
