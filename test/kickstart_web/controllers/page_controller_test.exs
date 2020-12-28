defmodule KickstartWeb.PageControllerTest do
  use KickstartWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Phoenix Kickstart · SaaS Template"
  end
end
