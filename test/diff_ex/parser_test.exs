defmodule DiffEx.ParserTest do
  use ExUnit.Case, async: true
  doctest DiffEx

  setup do
    {:ok, body} = File.read("test/fixtures/simple-commit.diff")

    {:ok, [contents: body]}
  end

  test "parse correctly returns array of files", %{contents: contents} do
    [file_1, file_2, _] = DiffEx.Parser.parse(contents)

    assert file_1.name == "test.txt"
    assert file_2.name == "simple-file.rb"
  end
end
