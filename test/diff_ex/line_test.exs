defmodule DiffEx.LineTest do
  use ExUnit.Case, async: true
  doctest DiffEx

  test "new_file? returns true if it is a new diff file" do
    line = "diff --git a/simple-file.rb b/simple-file.rb"

    assert DiffEx.Line.new_file?(line)
  end

  test "new_file? returns false if it is not a new diff file" do

    lines = [
      "new file mode 100644",
      "index 0000000..2919bef",
      "--- /dev/null",
      "+++ b/simple-file.rb",
      "@@ -0,0 +1,3 @@",
      "+class Foo"
    ]

    Enum.each(lines, fn (line) ->
      refute DiffEx.Line.new_file?(line), "line: #{line}"
    end)
  end
end
