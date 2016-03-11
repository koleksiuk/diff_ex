defmodule DiffEx.Parser.MainTest do
  use ExUnit.Case, async: true
  doctest DiffEx

  alias DiffEx.Parser.Main

  setup do
    {:ok, commit_1} = File.read("test/fixtures/simple-commit.diff")
    {:ok, commit_2} = File.read("test/fixtures/commit-with-line-changes.diff")

    {:ok, [commit_1: commit_1, commit_2: commit_2]}
  end

  test "parses correctly simple patch and returns array of files", %{ commit_1: commit_1 } do
    [file_1, file_2] = Main.parse(commit_1)

    assert file_1.new_name == "test.txt"
    assert file_1.old_name == "/dev/null"
    assert file_1.body == [
      "@@ -0,0 +1 @@",
      "+This is file content"
    ]

    assert file_2.new_name == "simple-file.rb"
    assert file_2.old_name == "/dev/null"
    assert file_2.body == [
      "@@ -0,0 +1,3 @@",
      "+class Foo",
      "+  attr_accessor :bar",
      "+end",
    ]
  end

  test "parses correctly and returns array of files", %{ commit_2: commit_2 } do
    [file_1] = Main.parse(commit_2)

    assert file_1.new_name == "simple-file.rb"
    assert file_1.body == [
      "@@ -1,3 +1,4 @@",
      " class Foo",
      "-  attr_accessor :bar",
      "+  attr_reader :foo",
      "+  attr_writer :bar",
      " end"
    ]
  end
end
