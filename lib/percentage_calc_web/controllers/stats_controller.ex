defmodule PercentageCalcWeb.StatsController do
  use PercentageCalcWeb, :controller

  alias PercentageCalc.Entries

  def index(conn, _params) do
    {avg, median, stats} = get_stats()

    render(conn, %{
      avg: avg,
      median: median,
      stats: stats
    })
  end

  defp get_stats do
    avg = Entries.get_percentage()
    median = Entries.get_median()
    stats = Entries.get_segment_stats()

    {
      :erlang.float_to_binary(avg, decimals: 2),
      :erlang.float_to_binary(median, decimals: 2),
      stats
    }
  end
end
