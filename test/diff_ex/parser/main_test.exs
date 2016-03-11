defmodule DiffEx.Parser.MainTest do
  use ExUnit.Case, async: true
  doctest DiffEx

  alias DiffEx.Parser.Main

  setup do
    {:ok, commit_1} = File.read("test/fixtures/simple-commit.diff")
    {:ok, commit_2} = File.read("test/fixtures/commit-with-line-changes.diff")
    {:ok, commit_3} = File.read("test/fixtures/multiline-changes.diff")
    {:ok, commit_4} = File.read("test/fixtures/multiple-area-changes.diff")

    commits = [
      commit_1: commit_1,
      commit_2: commit_2,
      commit_3: commit_3,
      commit_4: commit_4
    ]

    {:ok, commits}
  end

  test "parses correctly simple-patch.diff and returns array of files", %{ commit_1: commit } do
    [file_1, file_2] = Main.parse(commit)

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

  test "parses correctly commit-with-line-changes.diff and returns array of files", %{ commit_2: commit_2 } do
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

  test "parses correctly multiline-changes.diff and returns array of files", %{ commit_3: commit} do
    [file_1] = Main.parse(commit)

    assert file_1.new_name == "simple-file.rb"
    assert file_1.body == [
      "@@ -1,4 +1,7 @@",
      " class Foo",
      "-  attr_reader :foo",
      "+  attr_reader :foobar",
      "   attr_writer :bar",
      " end",
      "+",
      "+class Foo < Bar",
      "+end"
    ]
  end

  test "parses correctly multiple-area-changes.diff and returns array of files", %{ commit_4: commit} do
    [file_1] = Main.parse(commit)

    assert file_1.new_name == "simple-file.rb"
    assert file_1.body == [
      "@@ -1,3 +1,6 @@",
      "+class Object",
      "+end",
      "+",
      " class Foo",
      "   attr_reader :foobar",
      "   attr_writer :bar",
      "@@ -5,3 +8,5 @@ end",
      " ",
      " class Foo < Bar",
      " end",
      "+",
      "+puts \"done\""
    ]
  end
end
