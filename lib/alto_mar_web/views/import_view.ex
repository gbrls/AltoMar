defmodule AltoMarWeb.ImportView do
use AltoMarWeb, :view

def render("nmap_xml.html", assigns) do
  ~H"""
  <h1> Importing nmap.xml </h1>
  """
end

end
