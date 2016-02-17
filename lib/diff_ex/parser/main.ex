defmodule DiffEx.Parser.Main do
  alias DiffEx.Parser.Line, as: LineParser
  alias DiffEx.File, as: File

  def parse(contents) do
    contents
    |> String.split("\n")
    |> parse_diff([])
  end

  defp parse_diff([], files) do
    Enum.map(files, fn (file) -> Map.put(file, :body, Enum.reverse(file.body)) end)
  end

  defp parse_diff(contents, files) do
    parse_diff_content(nil, contents, files)
  end

  defp parse_diff_content(file, [], files) do
    parse_diff([], [file | files])
  end

  defp parse_diff_content(file, contents = [line | rest], files) do
    if LineParser.new_file?(line) do
      if file == nil do
        parse_diff_content(%File{}, rest, files)
      else
        parse_diff_content(%File{}, rest, [file | files])
      end
    else
      case LineParser.parse_line(line) do
        { :content, captures} -> merge_body(file, captures)
        { _regex_name, captures } -> Map.merge(file, captures)
        _ -> file
      end |> parse_diff_content(rest, files)
    end
  end

  defp merge_body(file, %{body: captured_body}) do
    Map.put(file, :body, [captured_body | file.body])
  end
end
