defmodule BlanksWeb.ClozeTestLive.Index do
  use BlanksWeb, :live_view

  alias Blanks.Accounts
  alias Blanks.ClozeTests

  @impl true
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    socket = socket
    |> assign(:page_title, "Your cloze tests")
    |> assign(:user_id, current_user.id)
    |> assign(:cloze_tests, list_cloze_tests(current_user.id))
    {:ok, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => cloze_test_id}, socket) do
    cloze_test = ClozeTests.get_user_cloze_test(socket.assigns.user_id, cloze_test_id)
    {:ok, _} = ClozeTests.delete_cloze_test(cloze_test)

    {:noreply, assign(socket, :cloze_tests, list_cloze_tests(socket.assigns.user_id))}
  end

  defp list_cloze_tests(user_id) do
    ClozeTests.list_user_cloze_tests(user_id)
  end
end
