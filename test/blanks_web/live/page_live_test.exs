defmodule BlanksWeb.PageLiveTest do
  use BlanksWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to"
    assert render(page_live) =~ "Welcome to"
  end
end
