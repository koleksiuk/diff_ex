defmodule DiffEx.Line do
  @new_file  ~r/^diff/
  @from_file ~r/^\-\-\-/
  @to_file   ~r/^\+\+\+ b\/(?<file_name>.*)/
  @content   ~r/^(?<body>[\ @\+\-\\].*)/

  def new_file?(line) do
    case Regex.run(@new_file, line) do
      nil -> false
      _   -> true
    end
  end

  def parse_line(line) when is_binary(line) do
    [
      {:file, @file},
      {:from_file, @from_file},
      {:to_file, @to_file},
      {:content, @content}
    ]
  end

  defp parsed_line(line, regex, {content, regex_match}) do
  end

  defp parsed_line(line, regex) do
    case Regex.run(regex, line) do
      nil -> nil
    end
  end
end
