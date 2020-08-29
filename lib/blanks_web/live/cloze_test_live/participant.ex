defmodule BlanksWeb.ClozeTestLive.Participant do
  use BlanksWeb, :live_view

  alias Blanks.ClozeTests
  alias Blanks.ClozeTests.ClozeTestSubmission

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
     |> assign(:changeset, ClozeTests.change_cloze_test_submission(%ClozeTestSubmission{}))
     |> assign(:cloze_test_html, cloze_test_html)}
  end

  @impl true
  def handle_event("form-submit", fillings, socket) do
    attrs = %{cloze_test_id: socket.assigns.cloze_test.id}
    fillings = fillings
      |> Map.delete("_csrf_token")
      |> Enum.map(fn {k, v} -> %{blank_id: k, value: v} end)

    case ClozeTests.create_cloze_test_submission(attrs, fillings) do
      {:ok, _submission} ->
        {:noreply, socket |> redirect(to: Routes.participant_path(socket, :success))}
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        {:noreply, socket |>  assign(changeset: changeset)}
    end
  end

  defp markdown_to_html(content) do
    {:ok, ast, []} = EarmarkParser.as_ast(content) # TODO: handle errors
    Blanks.Markdown.Transform.transform(ast, is_cloze_test: true, mode: :test)
  end
end
