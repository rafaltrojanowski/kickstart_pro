defmodule KickstartWeb.PricingPlanFormLive do
  use Phoenix.LiveView

  alias Kickstart.Accounts
  alias Kickstart.Accounts.PricingPlan

  def mount(_params, %{"action" => action, "csrf_token" => csrf_token} = session, socket) do
    pricing_plan = get_pricing_plan(session)

    assigns = [
      conn: socket,
      action: action,
      csrf_token: csrf_token,
      changeset: Accounts.change_pricing_plan(pricing_plan),
      pricing_plan: pricing_plan
    ]

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    KickstartWeb.Admin.PricingPlanView.render("form.html", assigns)
  end

  def handle_event("validate", %{"pricing_plan" => pricing_plan_params}, socket) do
    changeset =
      socket.assigns.pricing_plan
      |> PricingPlan.changeset(pricing_plan_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def get_pricing_plan(%{"id" => id} = _pricing_plan_params), do: Accounts.get_pricing_plan!(id)
  def get_pricing_plan(_pricing_plan_params), do: %PricingPlan{}
end
