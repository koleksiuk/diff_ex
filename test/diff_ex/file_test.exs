defmodule DiffEx.FileTest do
  use ExUnit.Case, async: true
  doctest DiffEx

  alias DiffEx.File
  alias DiffEx.Line

  setup do
    body = [
      "@@ -1,3 +1,4 @@",
      " class Foo",
      "-  attr_accessor :bar",
      "+  attr_reader :foo",
      "+  attr_writer :bar",
      " end"
    ]

    diff_file = %File{ new_path: "test.txt", body: body }

    {:ok, diff_file: diff_file}
  end

  test "added_lines/1 returns Line structs of added lines", %{diff_file: diff_file} do
    assert File.added_lines(diff_file) == [
      %Line { content: "+  attr_reader :foo" },
      %Line { content: "+  attr_writer :bar" }
    ]
  end

  test "removed_lines/1 returns Line structs of removed lines", %{diff_file: diff_file} do
    assert File.removed_lines(diff_file) == [
      %Line { content: "-  attr_accessor :bar" }
    ]
  end

  test "untouched_lines/1 returns Line structs of untouched lines", %{diff_file: diff_file} do
    assert File.untouched_lines(diff_file) == [
      %Line { content: " class Foo" },
      %Line { content: " end" }
    ]
  end

  test "name/1 returns File name", %{diff_file: diff_file} do
    assert File.name(diff_file) == "test.txt"
  end

  test "new_file?/1 returns true if old name is /dev/null" do
    diff_file = %File{ old_path: "/dev/null" }

    assert File.new_file?(diff_file)
  end

  test "new_file?/1 returns false if old name is not /dev/null" do
    diff_file = %File{ old_path: "filename.txt" }

    refute File.new_file?(diff_file)
  end
end
