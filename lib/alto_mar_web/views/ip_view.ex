defmodule AltoMarWeb.IPView do
  use AltoMarWeb, :view
  use Phoenix.Component

  def render("index.html", assigns) do
    ~H"""

    <p><a href="/import/upload"> upload </a> </p>

    <h1> Listing IPs </h1>
    <table>

    <%= for ip <- @ips do %>
    <tr>
      <td> <%= link ip.ip, to: Routes.ip_path(@conn, :show, ip.ip) %> </td>
      <td> <%= length(ip.services) %> </td>
    </tr>
    <% end %>

    </table>
    """
  end

  def render("show.html", assigns) do
    ~H"""
    <p> <%= link "All ips", to: Routes.ip_path(@conn, :index) %> </p>

    <h1><code> <%= @ip.ip %> </code></h1>

    <%= for service <- @ip.services do %>

      <.service_card service={service} />

    <% end %>

    <pre><%= inspect(@ip, pretty: true) %></pre>

    """
  end

  def card_cell(assigns) do
    ~H"""
    <%= if @data do %>
    <td> <%= @name %> <%= @data %> </td>
    <% else %>
    <% end %>
    """
  end

  def service_card(assigns) do
    ~H"""
    <div>
    <table>
      <tr>
        <.card_cell name="" data={@service.protocol |> String.upcase} />
        <.card_cell name="" data={@service.name} />
        <.card_cell name="" data={@service.cpe} />
        <.card_cell name="" data={@service.version} />
        <.card_cell name="" data={@service.product} />
        <.card_cell name="" data={@service.port} />
      </tr>
    </table>

    </div>
    """
  end
end
