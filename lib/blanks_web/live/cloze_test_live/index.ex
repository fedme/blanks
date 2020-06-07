defmodule BlanksWeb.ClozeTestLive.Index do
  use BlanksWeb, :live_view

  alias Blanks.ClozeTests
  alias Blanks.ClozeTests.ClozeTest

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :cloze_tests, list_cloze_tests())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Cloze test")
    |> assign(:cloze_test, ClozeTests.get_cloze_test!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Cloze test")
    |> assign(:cloze_test, %ClozeTest{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Cloze tests")
    |> assign(:cloze_test, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    cloze_test = ClozeTests.get_cloze_test!(id)
    {:ok, _} = ClozeTests.delete_cloze_test(cloze_test)

    {:noreply, assign(socket, :cloze_tests, list_cloze_tests())}
  end

  defp list_cloze_tests do
    ClozeTests.list_cloze_tests()
  end
end
