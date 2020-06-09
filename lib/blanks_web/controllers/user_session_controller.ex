defmodule BlanksWeb.UserSessionController do
  use BlanksWeb, :controller

  alias Blanks.Accounts
  alias BlanksWeb.UserAuth

  @page_title "User login"

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil, page_title: @page_title)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.login_user(conn, user, user_params)
    else
      render(conn, "new.html", error_message: "Invalid e-mail or password", page_title: @page_title)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.logout_user()
  end
end
