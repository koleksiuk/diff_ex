defmodule DiffEx.File do
  defstruct name: "", body: [], secure_hash: ""

  alias DiffEx.Line, as: Line

  @information ~r/^@@ .+\+(?<line_number>\d+),/
  @added_line ~r/^\+(?!\+|\+)/
  @untouched_line ~r/^[^-]/

  def added_lines(file) do
    fetch_added_lines(file.body)
  end

  defp fetch_added_lines(lines) do
    fetch_added_lines(lines, [])
  end

  defp fetch_added_lines([], converted_lines) do
    Enum.reverse(converted_lines)
  end

  defp fetch_added_lines([new_line | lines], converted_lines) do
    case Regex.run(@added_line, new_line) do
      nil -> fetch_added_lines(lines, converted_lines)
      _ -> fetch_added_lines(lines, [%Line{content: new_line} | converted_lines])
    end
  end
end
