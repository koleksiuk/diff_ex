defmodule DiffEx do
  def parse_file(diff_file_path) do
    {:ok, body } = File.read(diff_file_path)

    parse(body)
  end

  def parse(diff_contents) when is_binary(diff_contents) do
    DiffEx.Parser.Main.parse(diff_contents)
  end
end
