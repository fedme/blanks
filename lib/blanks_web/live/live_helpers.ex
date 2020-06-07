defmodule BlanksWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `BlanksWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, BlanksWeb.ClozeTestLive.FormComponent,
        id: @cloze_test.id || :new,
        action: @live_action,
        cloze_test: @cloze_test,
        return_to: Routes.cloze_test_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, BlanksWeb.ModalComponent, modal_opts)
  end
end
