defmodule BlanksWeb.ClozeTestLive.FormComponent do
  use BlanksWeb, :live_component

  alias Blanks.ClozeTests

  @impl true
  def update(%{cloze_test: cloze_test} = assigns, socket) do
    changeset = ClozeTests.change_cloze_test(cloze_test)

    socket = socket
    |> assign(assigns)
    |> assign(:changeset, changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"cloze_test" => cloze_test_params}, socket) do
    changeset =
      socket.assigns.cloze_test
      |> ClozeTests.change_cloze_test(cloze_test_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"cloze_test" => cloze_test_params}, socket) do
    save_cloze_test(socket, socket.assigns.action, cloze_test_params)
  end

  defp save_cloze_test(socket, :edit, cloze_test_params) do
    case ClozeTests.update_cloze_test(socket.assigns.cloze_test, cloze_test_params) do
      {:ok, _cloze_test} ->
        {:noreply,
         socket
         |> put_flash(:info, "Cloze test updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_cloze_test(socket, :new, cloze_test_params) do
    case ClozeTests.create_cloze_test(cloze_test_params) do
      {:ok, _cloze_test} ->
        {:noreply,
         socket
         |> put_flash(:info, "Cloze test created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
