defmodule AltoMarWeb.PageView do
  use AltoMarWeb, :view
end

defmodule AltoMarWeb.CommandsLive do
  use AltoMarWeb, :live_view
  require Logger

  def render(assigns) do
    ~H"""
    <code>
    <p> <%= inspect(@pid, pretty: true) %></p>
    <p> Status: <%= if !@done, do: "running", else: "done" %></p>
    <p> <%= @command %> </p>

    <%= for cmd <- @commands |> Enum.reverse() do %>
      <p>$ <%= cmd %> </p>
    <% end %>
    </code>

    """
  end

  def mount(_params, _session, socket) do
    command = "sleep 1 && ls ~/alto_mar/ && sleep 1 && echo bbbb && sleep 1 && echo cccc"

    if connected?(socket) do
      Logger.info("Starting liveview")

      Task.start_link(AltoMar, :cmd, [
        self(),
        command
      ])
    end

    {:ok,
     assign(socket, :commands, [])
     |> assign(:pid, self())
     |> assign(:command, command)
     |> assign(:done, false)}
  end

  def handle_info(:done, socket) do
    Logger.info("liveview rec :done")
    {:noreply, assign(socket, :done, true)}
  end

  def handle_info(msg, socket) do
    Logger.info(msg)
    {:noreply, assign(socket, :commands, [msg | socket.assigns.commands])}
  end
end
