defmodule DiffEx.Parser do
  import DiffEx.LineParser
  alias DiffEx.File, as: File

  def parse(contents) do
    contents
    |> String.split("\n")
    |> parse_diff([])
  end

  defp parse_diff([], files) do
    files
  end

  defp parse_diff(contents, files) do
    parse_diff(%File{}, contents, files)
  end

  defp parse_diff(file, [], files) do
    parse_diff([], [file | files])
  end

  defp parse_diff(file, contents = [line | rest], files) do
    if new_file?(line) do
      parse_diff(%File{}, rest, [file | files])
    else
      case parse_line(line) do
        { :content, captures} -> merge_body(file, captures)
        { _regex_name, captures } -> Map.merge(file, captures)
        _ -> file
      end |> parse_diff(rest, files)
    end
  end

  defp merge_body(file, capture) do
    file
    |> Map.put(:body, file.body <> capture["body"])
  end
end
