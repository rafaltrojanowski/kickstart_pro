defmodule KickstartWeb.SubscriptionController do
  use KickstartWeb, :controller

  alias Kickstart.Accounts

  alias Gringotts.Gateways.Stripe
  alias Gringotts.CreditCard

  import Ecto.Changeset

  def new(conn, %{"pricing_plan_id" => id}) do
    data  = %{}
    types = %{first_name: :string, last_name: :string, number: :string, year: :string, month: :string, verification_code: :string}

    changeset =
      {data, types}
      |> Ecto.Changeset.cast(data, Map.keys(types))
      |> validate_required([:first_name, :last_name, :number, :year, :month, :verification_code])

    pricing_plan = Accounts.get_pricing_plan!(id)
    render(conn, "new.html", pricing_plan: pricing_plan, changeset: changeset)
  end

  def create(conn, %{"subscription" => subscription_params}) do
    pricing_plan = Accounts.get_pricing_plan!(subscription_params["pricing_plan_id"])

    # Validation
    data  = %{}
    types = %{first_name: :string, last_name: :string, number: :string, year: :string, month: :string, verification_code: :string}

    changeset =
      {data, types}
      |> Ecto.Changeset.cast(subscription_params, Map.keys(types))
      |> validate_required([:first_name, :last_name, :number, :year, :month, :verification_code])

    if changeset.valid? do
      card = %CreditCard{
        first_name: subscription_params["first_name"],
        last_name: subscription_params["last_name"],
        number: subscription_params["number"],
        year: subscription_params["year"] |> String.to_integer,
        month: subscription_params["month"] |> String.to_integer,
        verification_code:  subscription_params["verification_code"]
      }
      IO.inspect(card)
      # TODO: Take a value from Pricing Plan here:
      amount = Money.new(19, :USD)
      IO.inspect(amount)

      value = Gringotts.purchase(Stripe, amount, card)

      cond do
        value["created"] ->
          IO.inspect("SUCCESS")
          IO.inspect(value)
          render(conn, "success.html")
        value["error"] ->
          IO.inspect("ERROR")
          IO.inspect(value)
          render(conn, "error.html")
      end
    else
      render(conn, "new.html", pricing_plan: pricing_plan, changeset: %{changeset | action: :insert})
    end
  end
end
