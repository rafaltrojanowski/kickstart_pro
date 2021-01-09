defmodule KickstartWeb.Admin.PricingPlanController do
  use KickstartWeb, :controller

  alias Kickstart.Accounts
  alias Kickstart.Accounts.PricingPlan

  plug(:put_layout, {KickstartWeb.LayoutView, "torch.html"})


  def index(conn, params) do
    case Accounts.paginate_pricing_plans(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Pricing plans. #{inspect(error)}")
        |> redirect(to: Routes.admin_pricing_plan_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_pricing_plan(%PricingPlan{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"pricing_plan" => pricing_plan_params}) do
    case Accounts.create_pricing_plan(pricing_plan_params) do
      {:ok, pricing_plan} ->
        conn
        |> put_flash(:info, "Pricing plan created successfully.")
        |> redirect(to: Routes.admin_pricing_plan_path(conn, :show, pricing_plan))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    pricing_plan = Accounts.get_pricing_plan!(id)
    render(conn, "show.html", pricing_plan: pricing_plan)
  end

  def edit(conn, %{"id" => id}) do
    pricing_plan = Accounts.get_pricing_plan!(id)
    changeset = Accounts.change_pricing_plan(pricing_plan)
    render(conn, "edit.html", pricing_plan: pricing_plan, changeset: changeset)
  end

  def update(conn, %{"id" => id, "pricing_plan" => pricing_plan_params}) do
    pricing_plan = Accounts.get_pricing_plan!(id)

    case Accounts.update_pricing_plan(pricing_plan, pricing_plan_params) do
      {:ok, pricing_plan} ->
        conn
        |> put_flash(:info, "Pricing plan updated successfully.")
        |> redirect(to: Routes.admin_pricing_plan_path(conn, :show, pricing_plan))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", pricing_plan: pricing_plan, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pricing_plan = Accounts.get_pricing_plan!(id)
    {:ok, _pricing_plan} = Accounts.delete_pricing_plan(pricing_plan)

    conn
    |> put_flash(:info, "Pricing plan deleted successfully.")
    |> redirect(to: Routes.admin_pricing_plan_path(conn, :index))
  end
end
