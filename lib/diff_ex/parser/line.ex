defmodule DiffEx.Parser.Line do
  @is_new_file  ~r/^diff/
  @new_file     ~r/^\-\-\- (?<old_name>\/dev\/null)/
  @from_file    ~r/^\-\-\- a\/(?<old_name>.*)/
  @to_file      ~r/^\+\+\+ b\/(?<new_name>.*)/
  @content      ~r/^(?<body>[\ @\+\-\\].*)/

  @regexes [
    {:from_file, @new_file},
    {:from_file, @from_file},
    {:to_file, @to_file},
    {:content, @content}
  ]

  def new_file?(line) do
    case Regex.run(@is_new_file, line) do
      nil -> false
      _   -> true
    end
  end

  def parse_line(line) when is_binary(line) do
    @regexes
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
    |> Enum.reduce(%{}, &accumulate_captures(&1, &2))
  end

  defp accumulate_captures({key, val}, acc) do
    Map.put(acc, String.to_atom(key), val)
  end
end
