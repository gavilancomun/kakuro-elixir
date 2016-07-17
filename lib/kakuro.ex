defmodule Kakuro do

defmodule EmptyCell do
  defstruct empty: ""
end

defmodule AcrossCell do
  defstruct across: 0
end

defmodule DownCell do
  defstruct down: 0
end

defmodule DownAcrossCell do
  defstruct down: 0, across: 0
end

defmodule ValueCell do
  defstruct values: [1, 2, 3, 4, 5, 6, 7, 8, 9]
end

def da(down, across) do
  %DownAcrossCell{down: down, across: across}
end

def d(down) do
  %DownCell{down: down}
end

def a(across) do
  %AcrossCell{across: across}
end

def v() do
  %ValueCell{values: [1, 2, 3, 4, 5, 6, 7, 8, 9]}
end

def v(values) do
  %ValueCell{values: values}
end

def e() do
  %EmptyCell{}
end

def pad2(n) do
 to_string(:io_lib.format("~2B", [n]))
end

defprotocol Draw do
  def draw(data)
end

defimpl Draw, for: EmptyCell do
  def draw(_), do: "   -----  " 
end

defimpl Draw, for: DownCell do
  def draw(data), do: "   " <> Kakuro.pad2(data.down) <> "\\--  "
end

defimpl Draw, for: AcrossCell do
  def draw(data), do: "   --\\" <> Kakuro.pad2(data.across) <> "  "
end

defimpl Draw, for: DownAcrossCell do
  def draw(data), do: "   " <> Kakuro.pad2(data.down) <> "\\" <> Kakuro.pad2(data.across) <> "  "
end

defimpl Draw, for: ValueCell do

  def drawValue(cell, value) do
    values = cell.values
    if MapSet.member?(MapSet.new(values), value) do
      to_string(value)
    else
      "."
    end
  end

  def draw(data) do
    case length(data.values) do
      1 -> "     " <> to_string(hd(data.values)) <> "    "
      _ -> " " <> ([1, 2, 3, 4, 5, 6, 7, 8, 9] |> Enum.map(fn x -> drawValue(data, x) end) |> Enum.join())
    end
  end
end

def drawRow(row) do
  (row |> Enum.map(fn x -> Draw.draw(x) end) |> Enum.join()) <> "\n"
end

def conj(coll, item) do
  coll ++ [item]
end

def allDifferent(coll) do
  length(coll) == MapSet.size(MapSet.new(coll))
end

def permute(vs, target, soFar) do
  if target >= 1 do
    if length(soFar) == (length(vs) - 1) do
      [conj(soFar, target)]
    else
      Enum.at(vs, length(soFar)).values |> Enum.flat_map(fn n -> permute(vs, (target - n), conj(soFar, n)) end)
    end
  else
    []
  end
end

def permuteAll(vs, target) do
  permute(vs, target, [])
end

end

