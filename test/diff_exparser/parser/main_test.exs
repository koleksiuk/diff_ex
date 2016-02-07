defmodule DiffEx.Parser.MainTest do
  use ExUnit.Case, async: true
  doctest DiffEx

  setup do
    {:ok, body} = File.read("test/fixtures/simple-commit.diff")

    {:ok, [contents: body]}
  end

  test "parse correctly returns array of files", %{contents: contents} do
    [file_1, file_2, _] = DiffEx.Parser.Main.parse(contents)

    assert file_1.name == "test.txt"
    assert file_1.body == [
      "@@ -0,0 +1 @@",
      "+This is file content"
    ]

    assert file_2.name == "simple-file.rb"
    assert file_2.body == [
      "@@ -0,0 +1,3 @@",
      "+class Foo",
      "+  attr_accessor :bar",
      "+end",
    ]
  end
end
