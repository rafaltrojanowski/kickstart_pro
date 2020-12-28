defmodule KickstartWeb.Admin.PricingPlanControllerTest do
  use KickstartWeb.ConnCase

  alias Kickstart.Accounts
  import Kickstart.AccountsFixtures

  @create_attrs %{description: "some description", name: "some name", period: "some period", price: "120.5", position: 1}
  @update_attrs %{description: "some updated description", name: "some updated name", period: "some updated period", price: "456.7", position: 2}
  @invalid_attrs %{description: nil, name: nil, period: nil, price: nil, position: nil}

  setup do
    %{admin: admin_fixture()}
  end

  def fixture(:pricing_plan) do
    {:ok, pricing_plan} = Accounts.create_pricing_plan(@create_attrs)
    pricing_plan
  end

  describe "index" do
    test "lists all pricing_plans", %{conn: conn, admin: admin} do
      conn =
      build_conn()
      |> log_in_user(admin)
      |> get(Routes.admin_pricing_plan_path(conn, :index))

      assert html_response(conn, 200) =~ "Pricing plans"
    end
  end

  describe "new pricing_plan" do
    test "renders form", %{conn: conn, admin: admin} do
      conn =
      build_conn()
      |> log_in_user(admin)
      |> get(Routes.admin_pricing_plan_path(conn, :new))
      assert html_response(conn, 200) =~ "New Pricing plan"
    end
  end

  describe "create pricing_plan" do
    test "redirects to show when data is valid", %{conn: conn, admin: admin} do
      conn =
      build_conn()
      |> log_in_user(admin)
      |> post(Routes.admin_pricing_plan_path(conn, :create), pricing_plan: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_pricing_plan_path(conn, :show, id)

      conn =
      build_conn()
      |> log_in_user(admin)
      |> get(Routes.admin_pricing_plan_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Pricing plan Details"
    end

    test "renders errors when data is invalid", %{conn: conn, admin: admin} do
      conn =
      build_conn()
      |> log_in_user(admin)
      |> post(Routes.admin_pricing_plan_path(conn, :create), pricing_plan: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Pricing plan"
    end
  end

  describe "edit pricing_plan" do
    setup [:create_pricing_plan]

    test "renders form for editing chosen pricing_plan", %{conn: conn, pricing_plan: pricing_plan, admin: admin} do
      conn =
      build_conn()
      |> log_in_user(admin)
      |> get(Routes.admin_pricing_plan_path(conn, :edit, pricing_plan))
      assert html_response(conn, 200) =~ "Edit Pricing plan"
    end
  end

  describe "update pricing_plan" do
    setup [:create_pricing_plan]

    test "redirects when data is valid", %{conn: conn, pricing_plan: pricing_plan, admin: admin} do
      conn =
      build_conn()
      |> log_in_user(admin)
      |> put(Routes.admin_pricing_plan_path(conn, :update, pricing_plan), pricing_plan: @update_attrs)
      assert redirected_to(conn) == Routes.admin_pricing_plan_path(conn, :show, pricing_plan)

      conn =
      build_conn()
      |> log_in_user(admin)
      |> get(Routes.admin_pricing_plan_path(conn, :show, pricing_plan))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, pricing_plan: pricing_plan, admin: admin} do
      conn =
      build_conn()
      |> log_in_user(admin)
      |> put(Routes.admin_pricing_plan_path(conn, :update, pricing_plan), pricing_plan: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Pricing plan"
    end
  end

  describe "delete pricing_plan" do
    setup [:create_pricing_plan]

    test "deletes chosen pricing_plan", %{conn: conn, pricing_plan: pricing_plan, admin: admin} do
      conn =
      build_conn()
      |> log_in_user(admin)
      |> delete(Routes.admin_pricing_plan_path(conn, :delete, pricing_plan))
      assert redirected_to(conn) == Routes.admin_pricing_plan_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, Routes.admin_pricing_plan_path(conn, :show, pricing_plan)
      end
    end
  end

  defp create_pricing_plan(_) do
    pricing_plan = fixture(:pricing_plan)
    {:ok, pricing_plan: pricing_plan}
  end
end
