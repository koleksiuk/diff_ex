defmodule DiffEx.File do
  defstruct old_path: "", new_path: "", body: [], secure_hash: ""

  alias DiffEx.Line, as: Line

  @information ~r/^@@ .+\+(?<line_number>\d+),/
  @added_line ~r/^\+(?!\+|\+)/
  @removed_line ~r/^\-(?!\+|\+)/
  @untouched_line ~r/^[^-+@]/

  def added_lines(file) do
    fetch_lines(file.body, @added_line)
  end

  def removed_lines(file) do
    fetch_lines(file.body, @removed_line)
  end

  def untouched_lines(file) do
    fetch_lines(file.body, @untouched_line)
  end

  def old_path(file), do: file.old_path
  def new_path(file), do: file.new_path
  def name(file), do: new_path(file)

  def new_file?(file) do
    is_null_path?(file.old_path)
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

  defp is_null_path?("/dev/null"), do: true
  defp is_null_path?(_), do: false
end
