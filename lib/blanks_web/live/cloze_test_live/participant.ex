defmodule BlanksWeb.ClozeTestLive.Participant do
  use BlanksWeb, :live_view

  alias Blanks.ClozeTests

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(:page_title, "Cloze test")
    |> assign(:hide_header, true)
    |> assign(:cloze_test_html, "")
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => cloze_test_id}, _, socket) do
    cloze_test = ClozeTests.get_cloze_test!(cloze_test_id)
    # TODO: handle cloze test null
    cloze_test_html = cloze_test.content |> markdown_to_html()

    {:noreply,
     socket
     |> assign(:cloze_test, cloze_test)
     |> assign(:cloze_test_html, cloze_test_html)}
  end

  @impl true
  def handle_event("form-submit", values, socket) do
    IO.inspect(values)
    {:noreply, socket}
  end

  defp markdown_to_html(content) do
    {:ok, ast, []} = EarmarkParser.as_ast(content) # TODO: handle errors
    Blanks.Markdown.Transform.transform(ast, is_cloze_test: true, is_preview: false)
  end
end
