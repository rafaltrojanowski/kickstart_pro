defmodule KickstartWeb.Admin.SubscriptionControllerTest do
  use KickstartWeb.ConnCase

  alias Kickstart.Accounts
  import Kickstart.AccountsFixtures

  @create_attrs %{
    end_at: ~N[2010-04-17 14:00:00],
    payment_response: %{},
    start_at: ~N[2010-04-17 14:00:00],
    status: "some status"
  }
  @update_attrs %{
    end_at: ~N[2011-05-18 15:01:01],
    payment_response: %{},
    start_at: ~N[2011-05-18 15:01:01],
    status: "some updated status"
  }
  @invalid_attrs %{end_at: nil, payment_response: nil, start_at: nil, status: nil}

  setup do
    %{admin: admin_fixture()}
  end

  def fixture(:subscription) do
    {:ok, subscription} = Accounts.create_subscription(@create_attrs)
    subscription
  end

  describe "index" do
    test "lists all subscriptions", %{conn: conn, admin: admin} do
      conn =
        build_conn()
        |> log_in_user(admin)
        |> get(Routes.admin_subscription_path(conn, :index))

      assert html_response(conn, 200) =~ "Subscriptions"
    end
  end

  # describe "new subscription" do
  #   test "renders form", %{conn: conn} do
  #     conn = get conn, Routes.admin_subscription_path(conn, :new)
  #     assert html_response(conn, 200) =~ "New Subscription"
  #   end
  # end

  # describe "create subscription" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     conn = post conn, Routes.admin_subscription_path(conn, :create), subscription: @create_attrs

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.admin_subscription_path(conn, :show, id)

  #     conn = get conn, Routes.admin_subscription_path(conn, :show, id)
  #     assert html_response(conn, 200) =~ "Subscription Details"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post conn, Routes.admin_subscription_path(conn, :create), subscription: @invalid_attrs
  #     assert html_response(conn, 200) =~ "New Subscription"
  #   end
  # end

  # describe "edit subscription" do
  #   setup [:create_subscription]

  #   test "renders form for editing chosen subscription", %{conn: conn, subscription: subscription} do
  #     conn = get conn, Routes.admin_subscription_path(conn, :edit, subscription)
  #     assert html_response(conn, 200) =~ "Edit Subscription"
  #   end
  # end

  # describe "update subscription" do
  #   setup [:create_subscription]

  #   test "redirects when data is valid", %{conn: conn, subscription: subscription} do
  #     conn = put conn, Routes.admin_subscription_path(conn, :update, subscription), subscription: @update_attrs
  #     assert redirected_to(conn) == Routes.admin_subscription_path(conn, :show, subscription)

  #     conn = get conn, Routes.admin_subscription_path(conn, :show, subscription)
  #     assert html_response(conn, 200) =~ "some updated status"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, subscription: subscription} do
  #     conn = put conn, Routes.admin_subscription_path(conn, :update, subscription), subscription: @invalid_attrs
  #     assert html_response(conn, 200) =~ "Edit Subscription"
  #   end
  # end

  describe "delete subscription" do
    setup [:create_subscription]

    test "deletes chosen subscription", %{conn: conn, subscription: subscription, admin: admin} do
      conn =
        build_conn()
        |> log_in_user(admin)
        |> delete(Routes.admin_subscription_path(conn, :delete, subscription))

      assert redirected_to(conn) == Routes.admin_subscription_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_subscription_path(conn, :show, subscription))
      end
    end
  end

  defp create_subscription(_) do
    subscription = fixture(:subscription)
    {:ok, subscription: subscription}
  end
end
