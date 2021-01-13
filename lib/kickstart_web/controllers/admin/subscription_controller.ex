defmodule KickstartWeb.Admin.SubscriptionController do
  use KickstartWeb, :controller

  alias Kickstart.Accounts
  alias Kickstart.Accounts.Subscription
  alias Kickstart.Repo

  plug(:put_layout, {KickstartWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case Accounts.paginate_subscriptions(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Subscriptions. #{inspect(error)}")
        |> redirect(to: Routes.admin_subscription_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_subscription(%Subscription{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"subscription" => subscription_params}) do
    case Accounts.create_subscription(subscription_params) do
      {:ok, subscription} ->
        conn
        |> put_flash(:info, "Subscription created successfully.")
        |> redirect(to: Routes.admin_subscription_path(conn, :show, subscription))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    subscription =
      Accounts.get_subscription!(id)
      |> Repo.preload([:user, :pricing_plan])

    render(conn, "show.html", subscription: subscription)
  end

  def edit(conn, %{"id" => id}) do
    subscription = Accounts.get_subscription!(id)
    changeset = Accounts.change_subscription(subscription)
    render(conn, "edit.html", subscription: subscription, changeset: changeset)
  end

  def update(conn, %{"id" => id, "subscription" => subscription_params}) do
    subscription = Accounts.get_subscription!(id)

    case Accounts.update_subscription(subscription, subscription_params) do
      {:ok, subscription} ->
        conn
        |> put_flash(:info, "Subscription updated successfully.")
        |> redirect(to: Routes.admin_subscription_path(conn, :show, subscription))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", subscription: subscription, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    subscription = Accounts.get_subscription!(id)
    {:ok, _subscription} = Accounts.delete_subscription(subscription)

    conn
    |> put_flash(:info, "Subscription deleted successfully.")
    |> redirect(to: Routes.admin_subscription_path(conn, :index))
  end
end
