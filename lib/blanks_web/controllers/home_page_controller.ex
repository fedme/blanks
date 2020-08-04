defmodule BlanksWeb.HomePageController do
  use BlanksWeb, :controller

  @page_title "Home"

  def index(conn, _params) do
    render(conn, "index.html", page_title: @page_title)
  end
end
