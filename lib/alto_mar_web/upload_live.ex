defmodule AltoMarWeb.UploadLive do
  use AltoMarWeb, :live_view
  require Logger

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:file, accept: ~w(.xml .json), max_entries: 32, max_file_size: 256_000_000)}
  end

  def render(assigns) do
    ~H"""
    <h1> Upload reports </h1>

    <form id="upload-form" phx-submit="save" phx-change="validate">
      <%= live_file_input @uploads.file %>
      <button type="submit">Upload</button>
    </form>

    <%= for entry <- @uploads.file.entries do %>
      <pre><%= entry |> inspect(pretty: true) %></pre>
    <% end %>

    <pre>
    </pre>

    """
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    name =
      consume_uploaded_entries(socket, :file, fn %{path: local_path}, entry ->
        local_path
        |> AltoMar.xml_to_map()
        |> Map.put(:upload_filename, entry.client_name)
        |> AltoMar.ReportWorker.store()

        {:ok, entry.client_name}
      end)
      |> Enum.join()

    {:noreply, socket |> put_flash(:info, "Uploaded #{name}")}
  end
end
