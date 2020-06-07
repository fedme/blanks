defmodule BlanksWeb.ClozeTestLive.Show do
  use BlanksWeb, :live_view

  alias Blanks.ClozeTests

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:cloze_test, ClozeTests.get_cloze_test!(id))}
  end

  defp page_title(:show), do: "Show Cloze test"
  defp page_title(:edit), do: "Edit Cloze test"
end
