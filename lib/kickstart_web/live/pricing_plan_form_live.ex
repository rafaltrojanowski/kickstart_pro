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

  def handle_event("add-feature", _, socket) do
    vars = Map.get(socket.assigns.changeset.changes, :features, socket.assigns.pricing_plan.features)

    features =
      vars
      |> Enum.concat([
        PricingPlans.change_feature(%Feature{temp_id: get_temp_id()})
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:features, features)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-variant", %{"remove" => remove_id}, socket) do
    variants =
      socket.assigns.changeset.changes.variants
      |> Enum.reject(fn %{data: variant} ->
        variant.temp_id == remove_id
      end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:variants, variants)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def get_pricing_plan(%{"id" => id} = _pricing_plan_params), do: Accounts.get_pricing_plan!(id)
  def get_pricing_plan(_pricing_plan_params), do: %PricingPlan{features: []}

  defp get_temp_id, do: :crypto.strong_rand_bytes(5) |> Base.url_encode64 |> binary_part(0, 5)
end
