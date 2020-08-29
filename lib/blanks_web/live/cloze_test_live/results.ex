defmodule BlanksWeb.ClozeTestLive.Results do
  use BlanksWeb, :live_view

  alias Blanks.ClozeTests
  alias Blanks.Accounts

  @impl true
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    socket = socket
      |> assign(:page_title, "Results")
      |> assign(:user_id, current_user.id)
      |> assign(:cloze_test_html, "")
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => cloze_test_id}, _, socket) do
    cloze_test = ClozeTests.get_cloze_test!(cloze_test_id)
    # TODO: handle cloze test null
    submissions = load_submissions(cloze_test)
    fillings = ClozeTests.get_all_fillings(submissions)
    blanks_ids = Map.keys(fillings)

    cloze_test_html = cloze_test.content |> markdown_to_html(fillings)

    {:noreply,
     socket
      |> assign(:cloze_test, cloze_test)
      |> assign(:submissions, submissions)
      |> assign(:blanks_ids, blanks_ids)
      |> assign(:selected_blank_id, blanks_ids |> Enum.at(0))
      |> assign(:fillings, fillings)
      |> assign(:cloze_test_html, cloze_test_html)}
  end

  @impl true
  def handle_event("blank-clicked", %{"blank_id" => blank_id}, socket) do
    {:noreply,
     socket
      |> assign(:selected_blank_id, blank_id)
    }
  end

  defp load_submissions(cloze_test) do
    ClozeTests.list_cloze_test_submissions(cloze_test.id, true)
  end

  defp markdown_to_html(content, fillings) do
    {:ok, ast, []} = EarmarkParser.as_ast(content) # TODO: handle errors
    Blanks.Markdown.Transform.transform(ast, is_cloze_test: true, mode: :results, fillings: fillings)
  end
end
