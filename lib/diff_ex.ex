defmodule DiffEx do
  def parse_file(diff_file_path) do
    {:ok, body } = File.read(diff_file_path)

    body |> parse
  end

  def parse(diff_contents) when is_binary(diff_contents) do
    DiffEx.Parser.parse(diff_contents)
  end
end
