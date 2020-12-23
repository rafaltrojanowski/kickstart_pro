defmodule KickstartWeb.Admin.FaqController do
  use KickstartWeb, :controller

  alias Kickstart.Site
  alias Kickstart.Site.Faq


  plug(:put_layout, {KickstartWeb.LayoutView, "torch.html"})


  def index(conn, params) do
    case Site.paginate_faqs(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Faqs. #{inspect(error)}")
        |> redirect(to: Routes.admin_faq_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Site.change_faq(%Faq{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"faq" => faq_params}) do
    case Site.create_faq(faq_params) do
      {:ok, faq} ->
        conn
        |> put_flash(:info, "Faq created successfully.")
        |> redirect(to: Routes.admin_faq_path(conn, :show, faq))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    faq = Site.get_faq!(id)
    render(conn, "show.html", faq: faq)
  end

  def edit(conn, %{"id" => id}) do
    faq = Site.get_faq!(id)
    changeset = Site.change_faq(faq)
    render(conn, "edit.html", faq: faq, changeset: changeset)
  end

  def update(conn, %{"id" => id, "faq" => faq_params}) do
    faq = Site.get_faq!(id)

    case Site.update_faq(faq, faq_params) do
      {:ok, faq} ->
        conn
        |> put_flash(:info, "Faq updated successfully.")
        |> redirect(to: Routes.admin_faq_path(conn, :show, faq))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", faq: faq, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    faq = Site.get_faq!(id)
    {:ok, _faq} = Site.delete_faq(faq)

    conn
    |> put_flash(:info, "Faq deleted successfully.")
    |> redirect(to: Routes.admin_faq_path(conn, :index))
  end
end
