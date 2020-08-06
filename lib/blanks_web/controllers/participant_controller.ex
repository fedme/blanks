defmodule BlanksWeb.ParticipantController do
  use BlanksWeb, :controller

  @page_title "Thank you!"

  def success(conn, _params) do
    render(conn, "success.html", page_title: @page_title, hide_header: true)
  end
end
