defmodule BlanksWeb.ClozeTestLive.Edit do
  use BlanksWeb, :live_view

  alias Blanks.Accounts
  alias Blanks.ClozeTests
  alias Blanks.ClozeTests.ClozeTest

  @impl true
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    socket = socket
    |> assign(:user_id, current_user.id)
    |> assign(:preview_html, "")
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:changeset, ClozeTests.change_cloze_test(ClozeTests.get_cloze_test!(id), %{}))}
  end

  @impl true
  def handle_params(_, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:changeset, ClozeTests.change_cloze_test(%ClozeTest{}, %{name: "New Test", content: "The [food](1) is [great](2) *here*.", user_id: socket.assigns.user_id}))}
  end

  @impl true
  def handle_event("change", %{"cloze_test" => params}, socket) do
    # params = Map.update(params, "content", "", &(HtmlSanitizeEx.strip_tags(&1)))

    {:ok, ast, []} = Map.get(params, "content", "") |> EarmarkParser.as_ast()

    IO.inspect(ast)

    preview_html = Blanks.Markdown.Transform.transform(ast)

    IO.inspect(preview_html)

    changeset =
      %ClozeTest{}
      |> ClozeTests.change_cloze_test(params)
      |> Map.put(:action, :insert)

    socket =
      assign(socket,
        changeset: changeset,
        preview_html: preview_html
      )

    {:noreply, socket}
  end

  defp page_title(:new), do: "New Cloze test"
  defp page_title(:edit), do: "Edit Cloze test"
end
