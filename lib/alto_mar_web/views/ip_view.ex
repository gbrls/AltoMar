defmodule AltoMarWeb.IPView do
  use AltoMarWeb, :view

  def render("index.html", assigns) do
    ~H"""

    <p><a href="/import/upload"> upload </a> </p>

    <h1> Listing IPs </h1>
    <table>

    <%= for ip <- @ips do %>
    <tr>
      <td> <%= link ip.ip, to: Routes.ip_path(@conn, :show, ip.ip) %> </td>
    </tr>
    <% end %>

    </table>
    """
  end

  def render("show.html", assigns) do
    ~H"""
    <p> <%= link "All ips", to: Routes.ip_path(@conn, :index) %> </p>
    
    <h1><code> <%= @ip.ip %> </code></h1>

    <pre><%= inspect(@ip, pretty: true) %></pre>

    """
  end
end
