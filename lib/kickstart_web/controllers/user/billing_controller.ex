defmodule KickstartWeb.BillingController do
  use KickstartWeb, :controller

  alias Kickstart.Repo
  alias Kickstart.Accounts
  import Ecto.Query

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    time_now = NaiveDateTime.utc_now

    query = from s in "subscriptions",
      where: s.user_id == ^user_id and s.start_at < ^time_now and (s.end_at > ^time_now or is_nil(s.end_at)),
      select: [s.id, s.pricing_plan_id]

    current_subscription_id = Enum.at(Repo.one(query), 0)
    current_pricing_plan_id = Enum.at(Repo.one(query), 1)
    current_pricing_plan = Accounts.get_pricing_plan!(current_pricing_plan_id)
    current_subscription = Accounts.get_subscription!(current_subscription_id)

    render(conn, "index.html", current_pricing_plan: current_pricing_plan, current_subscription: current_subscription)
  end
end
