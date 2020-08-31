defmodule BlanksWeb.ClozeTestLive.Edit do
  use BlanksWeb, :live_view

  alias Blanks.Accounts
  alias Blanks.ClozeTests
  alias Blanks.ClozeTests.ClozeTest

  @impl true
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    socket = socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:user_id, current_user.id)
    |> assign(:preview_html, "")
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => cloze_test_id}, _, socket) do
    cloze_test = ClozeTests.get_user_cloze_test(socket.assigns.user_id, cloze_test_id)
    # TODO: handle cloze test null
    preview_html = cloze_test.content |> markdown_to_html()

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:cloze_test_id, cloze_test_id)
     |> assign(:changeset, ClozeTests.change_cloze_test(cloze_test, %{}))
     |> assign(:preview_html, preview_html)}
  end

  @impl true
  def handle_params(_, _, socket) do
    initial_values = %{name: "New Test", content: "# This is a title\nThe food is [great](838YBkQAj) *here*.", user_id: socket.assigns.user_id}
    preview_html = initial_values.content |> markdown_to_html()

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:cloze_test_id, :new)
     |> assign(:changeset, ClozeTests.change_cloze_test(%ClozeTest{}, initial_values))
     |> assign(:preview_html, preview_html)}
  end

  @impl true
  def handle_event("content-changed", content, socket) do
    preview_html = markdown_to_html(content)
    {:noreply,
      socket
      |> assign(:preview_html, preview_html)}
  end

  def handle_event("editor-submit", %{"cloze_test" => params}, socket) do
    params = params |> Map.put("user_id", socket.assigns.user_id)
    case save_cloze_test(socket.assigns.cloze_test_id, params) do
      {:ok, cloze_test} ->
        # TODO: update list of tests
        {:noreply, push_patch(socket, to: Routes.cloze_test_edit_path(socket, :edit, cloze_test))}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, changeset: changeset)
        {:noreply, socket}
    end
  end

  defp page_title(:new), do: "New cloze test"
  defp page_title(:edit), do: "Edit cloze test"

  defp markdown_to_html(content) do
    {:ok, ast, []} = EarmarkParser.as_ast(content) # TODO: handle errors
    Blanks.Markdown.Transform.transform(ast, is_cloze_test: true, mode: :preview)
  end

  defp save_cloze_test(:new, params) do
    ClozeTests.create_cloze_test(params)
  end

  defp save_cloze_test(cloze_test_id, params) do
    cloze_test = ClozeTests.get_cloze_test!(cloze_test_id)
    ClozeTests.update_cloze_test(cloze_test, params)
  end
end
