defmodule DiffEx.Parser.Line do
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
    captures = regex
    |> Regex.named_captures(line)
    |> captures_to_atoms

    {regex_name, captures}
  end

  defp captures_to_atoms(nil), do: nil

  defp captures_to_atoms(captures) do
    captures
    |> Enum.reduce(%{}, fn ({key, val}, acc) ->
      Map.put(acc, String.to_atom(key), val)
    end)
  end
end
