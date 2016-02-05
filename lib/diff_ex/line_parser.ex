defmodule DiffEx.LineParser do
  @new_file  ~r/^diff/
  @from_file ~r/^\-\-\-/
  @to_file   ~r/^\+\+\+ b\/(?<name>.*)/
  @content   ~r/^(?<body>[\ @\+\-\\].*)/

  def new_file?(line) do
    case Regex.run(@new_file, line) do
      nil -> false
      _   -> true
    end
  end

  def parse_line(line) when is_binary(line) do
    regexes = [
      {:from_file, @from_file},
      {:to_file, @to_file},
      {:content, @content}
    ]

    regexes
    |> Enum.map(&process_line(line, &1))
    |> Enum.find(fn ({_name, el}) -> el != nil end)
  end

  defp process_line(line, {regex_name, regex}) do
    {regex_name, Regex.named_captures(regex, line)}
  end
end
