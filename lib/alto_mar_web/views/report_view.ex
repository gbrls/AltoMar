defmodule AltoMarWeb.ReportView do
  use AltoMarWeb, :view
  import AltoMar, only: [id: 1, ip: 1]

  def title(assigns) do
  ~H"""
    <tt> <%= @report.ip %> </tt> | <%= @report.date %> 
  """
    
  end

  def render("new_test.html", assigns) do
    ~H"""
    <h1> New User </h1>

    <%= form_for @changeset, Routes.report_path(@conn, :create), fn f -> %>
    <div>
      <%= text_input f, :date,  placeholder: "Date" %>
    </div>
    <div>
      <%= text_input f, :ip,  placeholder: "0.0.0.0" %>
    </div>
    <%= submit "Create Report" %>
    <% end %>
    """
  end

end
