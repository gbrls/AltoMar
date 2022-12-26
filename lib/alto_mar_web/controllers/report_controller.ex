defmodule AltoMarWeb.ReportController do
  require Logger
  use AltoMarWeb, :controller

  def index(conn, _params) do
    reports = AltoMar.list_reports()
    render(conn, :index, reports: reports)
  end

  def show(conn, %{"id" => id}) do
    report = AltoMar.get_report_by!(date: id)
    IO.inspect(report)
    render(conn, :show, report: report)
  end

  def create(conn, %{"report" => indata}) do
    case AltoMar.create_report(indata) do
      {:ok, report} ->
        conn
        |> put_flash(:info, "#{inspect(report, pretty: true)} created!")
        |> redirect(to: Routes.report_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Cannot create this report")
        |> redirect(to: Routes.report_path(conn, :new_test))

    end
  end

  def new_test(conn, _params) do
    changeset = AltoMar.change_report(%AltoMar.Report{})
    Logger.info(inspect(changeset, pretty: true))
    render(conn, :new_test, changeset: changeset)
  end
end
