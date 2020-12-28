defmodule KickstartWeb.SubscriptionController do
  use KickstartWeb, :controller

  alias Kickstart.Accounts
  alias Kickstart.Accounts.Subscription
  alias Kickstart.Repo

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
      amount = Money.new(pricing_plan.price, :USD)
      response = Gringotts.purchase(Stripe, amount, card)

      cond do
        response["created"] ->
          create_subscription(conn.assigns.current_user, pricing_plan, response)
          render(conn, "success.html")
        response["error"] ->
          IO.inspect(response)
          render(conn, "error.html")
      end
    else
      render(conn, "new.html", pricing_plan: pricing_plan, changeset: %{changeset | action: :insert})
    end
  end

  defp create_subscription(user, pricing_plan, data) do
    time_now = NaiveDateTime.utc_now
    start_at = time_now |> NaiveDateTime.truncate(:second)
    end_at = case pricing_plan.period do
      "month" ->
        Timex.shift(time_now, months: 1) |> NaiveDateTime.truncate(:second)
      "year" ->
        Timex.shift(time_now, years: 1) |> NaiveDateTime.truncate(:second)
      "one-time" ->
        nil
      end

    %Subscription{
      user: user,
      pricing_plan: pricing_plan,
      start_at: start_at,
      end_at: end_at,
      status: "paid",
      payment_response: data}
    |> Repo.insert
  end
end
