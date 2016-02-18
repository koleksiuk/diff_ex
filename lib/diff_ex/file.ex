defmodule DiffEx.File do
  defstruct name: "", body: [], secure_hash: ""

  alias DiffEx.Line, as: Line

  @information ~r/^@@ .+\+(?<line_number>\d+),/
  @added_line ~r/^\+(?!\+|\+)/
  @removed_line ~r/^\-(?!\+|\+)/
  @untouched_line ~r/^[^-]/

  def added_lines(file) do
    fetch_lines(file.body, @added_line)
  end

  def removed_lines(file) do
    fetch_lines(file.body, @removed_line)
  end

  def untouched_lines(file) do
    fetch_lines(file.body, @untouched_line)
  end

  defp fetch_lines(lines, regex) do
    fetch_lines(lines, [], regex)
  end

  defp fetch_lines([], converted_lines, regex) do
    Enum.reverse(converted_lines)
  end

  defp fetch_lines([new_line | lines], converted_lines, regex) do
    case Regex.run(regex, new_line) do
      nil -> fetch_lines(lines, converted_lines, regex)
      _ -> fetch_lines(lines, [%Line{content: new_line} | converted_lines], regex)
    end
  end
end
