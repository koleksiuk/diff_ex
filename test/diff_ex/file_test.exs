defmodule DiffEx.FileTest do
  use ExUnit.Case, async: true
  doctest DiffEx

  setup do
    body = [
      "@@ -1,3 +1,4 @@",
      " class Foo",
      "-  attr_accessor :bar",
      "+  attr_reader :foo",
      "+  attr_writer :bar",
      " end"
    ]

    diff_file = %DiffEx.File { name: "test.txt", body: body }

    {:ok, diff_file: diff_file}
  end

  test "added_lines/1 returns Line structs of added lines", %{diff_file: diff_file} do
    assert DiffEx.File.added_lines(diff_file) == [
      %DiffEx.Line { content: "+  attr_reader :foo" },
      %DiffEx.Line { content: "+  attr_writer :bar" }
    ]
  end

  test "removed_lines/1 returns Line structs of removed lines", %{diff_file: diff_file} do
    assert DiffEx.File.removed_lines(diff_file) == [
      %DiffEx.Line { content: "-  attr_accessor :bar" }
    ]
  end

  test "untouched_lines/1 returns Line structs of untouched lines", %{diff_file: diff_file} do
    assert DiffEx.File.untouched_lines(diff_file) == [
      %DiffEx.Line { content: " class Foo" },
      %DiffEx.Line { content: " end" }
    ]
  end
end
