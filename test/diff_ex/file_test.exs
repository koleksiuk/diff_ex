defmodule DiffEx.FileTest do
  use ExUnit.Case, async: true
  doctest DiffEx

  setup do
    body = [
      "@@ -0,0 +1 @@",
      "+This is file content"
    ]

    diff_file = %DiffEx.File { name: "test.txt", body: body }

    {:ok, diff_file: diff_file}
  end

  test "added_lines/1 returns Line structs of added lines", %{diff_file: diff_file} do
    assert DiffEx.File.added_lines(diff_file) == [
      %DiffEx.Line { content: "+This is file content" }
    ]
  end
end
