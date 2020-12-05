defmodule Advent2020 do
  use Application
  @moduledoc """
  Documentation for `Advent2020`.
  """

  # IDK what is wrong with this and I've had enough
  def start(_type, _args) do
    Supervisor.start_link(Day3.run(), [])
  end
end
