defmodule AltoMar do
  require Logger

  alias AltoMar.Repo
  alias AltoMar.Report

  @moduledoc """
  AltoMar keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def xml_to_map(path) do
    path |> File.read!() |> XmlToMap.naive_map()
  end

  def list_reports() do
    # ["/Users/gabriel.shneider/alto_mar/nmap-1.xml", "/Users/gabriel.shneider/alto_mar/nmap-2.xml"]
    # |> Enum.map(&(&1 |> File.read!() |> XmlToMap.naive_map()))
    Repo.all(Report)
  end

  def get_report_by(params) do
    Repo.get_by(Report, params)
  end

  def get_report_by!(params) do
    Repo.get_by!(Report, params)
  end

  def get_report(id) do
    Repo.get(Report, id)
  end

  def get_report!(id) do
    Repo.get!(Report, id)
  end

  def id(%{date: date}) do
    date
  end

  def ip(%{ip: ip}) do
    Repo.get_by!(:ip, ip)
  end

  def change_report(%Report{} = report) do
    Report.changeset(report, %{})
  end

  def create_report(attrs \\ %{}) do
    %Report{}
    |> Report.changeset(attrs)
    |> Repo.insert()
  end

  def cmd(pid, cmd) do
    System.cmd("bash", ["-c", cmd], into: pid)
  end
end

defimpl Collectable, for: PID do
  require Logger

  def into(pid) do
    col_fun = fn
      acc, {:cont, x} ->
        Logger.info("Sending #{inspect(x, pretty: true)} to #{inspect(acc, pretty: true)}")
        send(acc, x)
        acc

      acc, :done ->
        send(acc, :done)
        acc

      _acc, :halt ->
        :ok
    end

    {pid, col_fun}
  end
end

defmodule AltoMar.ReportWorker do
  @moduledoc """
  This module receives maps as reports and adds them to the database.
  """
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(_init) do
    Logger.info("[#{__MODULE__}] started")
    {:ok, []}
  end

  def handle_cast({:store, %{upload_filename: fname} = report}, state) do
    Logger.info("[#{__MODULE__}] cast")
    Logger.info("[#{__MODULE__}] #{fname}")

    hosts = get_in(report, ["nmaprun", "#content", "host"])

    with {:ok, json} <-
           Jason.encode(report) do
      File.write!("/Users/gabriel.shneider/alto_mar/#{fname}.json", json)
    end

    case hosts do
      %{} = mp ->
        Logger.info("ONE HOST")
        [report_from_ip(mp)]

      [_ | _] = arr ->
        Logger.info("MANY HOSTS")
        Enum.map(arr, &report_from_ip(&1))
    end

    {:noreply, state}
  end

  # Maybe commiting war crimes here?
  def store(report, pid \\ AltoMar.ReportWorker) do
    GenServer.cast(pid, {:store, report})
  end

  def report_from_ip(mp) do
    ip = get_in(mp, ["#content", "address", "-addr"])
    port_loc = get_in(mp, ["#content", "ports", "port"])

    if !is_nil(port_loc) do
      ports = port_loc |> Enum.map(&get_service/1)
      Logger.info(ip)
      Logger.info(inspect(ports, pretty: true))
    end
  end

  def get_service(mp) do
    {_, y} =
      {mp, %{}}
      |> port_n_protocol()
      |> then(field(["#content", "service", "#content", "cpe"], :cpe))
      |> then(field(["#content", "service", "-product"], :product))
      |> then(field(["#content", "service", "-version"], :version))
      |> then(field(["#content", "service", "-hostname"], :hostname))
      |> then(field(["#content", "service", "-name"], :name))
      |> then(field(["#content", "service", "-ostype"], :os))

    y
  end

  def port_n_protocol({x, y}) do
    case x do
      %{"-portid" => port, "-protocol" => protocol} ->
        {x, y |> Map.put(:port, port |> String.to_integer()) |> Map.put(:protocol, protocol)}

      _ ->
        {x, y}
    end
  end

  def cpe({x, y}) do
    case x do
      %{"#content" => %{"service" => %{"#content" => %{"cpe" => cpe}}}} ->
        {x,
         y
         |> Map.put(
           :cpe,
           case cpe do
             [_, _] = l -> Enum.join(l, "\n")
             n -> n
           end
         )}

      _ ->
        {x, y}
    end
  end

  def field(path, name, f \\ fn x -> x end) do
    gf = fn {x, y} ->
      data = get_in(x, path)

      if !is_nil(data) do
        {x, y |> Map.put(name, f.(data))}
      else
        {x, y}
      end
    end
    gf
  end
end