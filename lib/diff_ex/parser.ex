defmodule DiffEx.Parser do
  def parse(contents) do
    parse_diff(contents, [])
  end

  defp parse_diff("", patches) do
    patches
  end

  defp parse_diff(contents) do
    parse_diff("", [])
  end
end
