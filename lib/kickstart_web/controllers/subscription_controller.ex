defmodule KickstartWeb.SubscriptionController do
  use KickstartWeb, :controller

  alias Kickstart.Accounts
  alias Kickstart.Accounts.PricingPlan

  alias Gringotts.Gateways.Stripe
  alias Gringotts.CreditCard

  def new(conn, %{"pricing_plan_id" => id}) do
    pricing_plan = Accounts.get_pricing_plan!(id)
    render(conn, "new.html", pricing_plan: pricing_plan)
  end

  def create(conn, %{"subscription" => subscription_params}) do
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

  end
end
