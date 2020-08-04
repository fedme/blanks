defmodule BlanksWeb.ClozeTestLive.Participant do
  use BlanksWeb, :live_view

  alias Blanks.Accounts
  alias Blanks.ClozeTests
  alias Blanks.ClozeTests.ClozeTest

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:preview_html, "")
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => cloze_test_id}, _, socket) do
    cloze_test = ClozeTests.get_cloze_test!(cloze_test_id)
    # TODO: handle cloze test null
    preview_html = cloze_test.content |> markdown_to_html()

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:cloze_test_id, cloze_test_id)
     |> assign(:preview_html, preview_html)}
  end

  @impl true
  def handle_event("preview-change", values, socket) do
    IO.inspect(values)
    {:noreply, socket}
  end

  defp page_title(:new), do: "New cloze test"
  defp page_title(:edit), do: "Edit cloze test"

  defp markdown_to_html(content) do
    {:ok, ast, []} = EarmarkParser.as_ast(content) # TODO: handle errors
    Blanks.Markdown.Transform.transform(ast, is_cloze_test: true, is_preview: false)
  end
end
