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
    cloze_test = ClozeTests.get_cloze_test!(id)
    preview_html = cloze_test.content |> markdown_to_html()

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:cloze_test_id, id)
     |> assign(:changeset, ClozeTests.change_cloze_test(cloze_test, %{}))
     |> assign(:preview_html, preview_html)}
  end

  @impl true
  def handle_params(_, _, socket) do
    initial_values = %{name: "New Test", content: "The [food](1) is [great](2) *here*.", user_id: socket.assigns.user_id}
    preview_html = initial_values.content |> markdown_to_html()

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:cloze_test_id, :noid)
     |> assign(:changeset, ClozeTests.change_cloze_test(%ClozeTest{}, initial_values))
     |> assign(:preview_html, preview_html)}
  end

  @impl true
  def handle_event("editor-change", %{"cloze_test" => params}, socket) do
    changeset =
      %ClozeTest{}
      |> ClozeTests.change_cloze_test(params)
      |> Map.put(:action, :insert)

    preview_html = Map.get(params, "content", "") |> markdown_to_html()

    {:noreply,
      socket
      |> assign(:changeset, changeset)
      |> assign(:preview_html, preview_html)}
  end

  def handle_event("editor-submit", %{"cloze_test" => params}, socket) do
    IO.puts("editor-submit")
    params = params |> Map.put("user_id", socket.assigns.user_id)
    case save_cloze_test(socket.assigns.cloze_test_id, params) do
      {:ok, _cloze_test} ->
        # TODO: update list of tests
        IO.puts("saved ok")
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("saved error")
        IO.inspect(changeset)
        socket = assign(socket, changeset: changeset)
        {:noreply, socket}
    end
  end


  def handle_event("preview-change", values, socket) do
    IO.inspect(values)
    {:noreply, socket}
  end

  defp page_title(:new), do: "New Cloze test"
  defp page_title(:edit), do: "Edit Cloze test"

  defp markdown_to_html(content) do
    {:ok, ast, []} = EarmarkParser.as_ast(content) # TODO: handle errors
    Blanks.Markdown.Transform.transform(ast, is_cloze_test: true, is_preview: true)
  end

  defp save_cloze_test(:noid, params) do
    ClozeTests.create_cloze_test(params)
  end

  defp save_cloze_test(cloze_test_id, params) do
    cloze_test = ClozeTests.get_cloze_test!(cloze_test_id)
    ClozeTests.update_cloze_test(cloze_test, params)
  end
end
