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
  defstruct values: [1, 2, 3, 4, 5, 6, 7, 8, 9] |> MapSet.new
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
  %ValueCell{values: MapSet.new([1, 2, 3, 4, 5, 6, 7, 8, 9])}
end

def v(values) do
  %ValueCell{values: MapSet.new(values)}
end

def e() do
  %EmptyCell{}
end

def pad2(n) do
 to_string(:io_lib.format("~2B", [n]))
end

defprotocol Cell do
  def draw(data)
end

defimpl Cell, for: EmptyCell do
  def draw(_), do: "   -----  " 
end

defimpl Cell, for: DownCell do
  def draw(data), do: "   " <> Kakuro.pad2(data.down) <> "\\--  "
end

defimpl Cell, for: AcrossCell do
  def draw(data), do: "   --\\" <> Kakuro.pad2(data.across) <> "  "
end

defimpl Cell, for: DownAcrossCell do
  def draw(data), do: "   " <> Kakuro.pad2(data.down) <> "\\" <> Kakuro.pad2(data.across) <> "  "
end

defimpl Cell, for: ValueCell do

  def drawValue(cell, value) do
    values = cell.values
    if MapSet.member?(values, value) do
      to_string(value)
    else
      "."
    end
  end

  def draw(data) do
    case MapSet.size(data.values) do
      1 -> "     " <> to_string(Enum.at(data.values, 0)) <> "    "
      _ -> " " <> ([1, 2, 3, 4, 5, 6, 7, 8, 9] |> Enum.map(fn x -> drawValue(data, x) end) |> Enum.join())
    end
  end
end

def drawRow(row) do
  (row |> Enum.map(fn x -> Cell.draw(x) end) |> Enum.join()) <> "\n"
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

def transpose(m) do
  if 0 == length(m) do
    []
  else
    0 .. (length(Enum.at(m, 0)) - 1) |> Enum.map(fn i -> m |> Enum.map(fn col -> Enum.at(col, i) end) end)
  end
end

def partitionBy(f, coll) do
  if 0 == length(coll) do
    []
  else
    head = hd(coll)
    fx = f.(head)
    group = coll |> Enum.take_while(fn y -> fx == f.(y) end)
    [group] ++ partitionBy(f, coll |> Enum.drop(length(group)))
  end
end

def partitionAll(n, step, coll) do
  if Enum.empty? coll do
    []
  else
    [coll |> Enum.take(n)] ++ partitionAll(n, step, coll |> Enum.drop(step))
  end
end

def partitionN(n, coll) do
  partitionAll(n, n, coll)
end

def isPossible(v, n) do
  v.values |> Enum.any?(fn item -> item == n end)
end

def solveStep(cells, total) do
  finalIndex = length(cells) - 1
  perms = permuteAll(cells, total)
        |> Enum.filter(fn v -> isPossible(List.last(cells), Enum.at(v, finalIndex)) end)
        |> Enum.filter(fn v -> allDifferent(v) end)
  transpose(perms) |> Enum.map(fn coll -> v(coll) end)
end

def gatherValues(line) do
  partitionBy(fn v ->
    case v do
      %ValueCell{} -> true
      _ -> false
    end
  end, line)
end

def pairTargetsWithValues(line) do
  partitionN(2, gatherValues(line))
end

def solvePair(f, pair) do
  notValueCells = pair |> Enum.at(0)
  if (nil == pair |> Enum.at(1)) or (0 == pair |> Enum.at(1) |> length()) do
    notValueCells
  else
    valueCells = pair |> Enum.at(1)
    newValueCells = solveStep(valueCells, f.(List.last(notValueCells)))
    notValueCells ++ newValueCells
  end 
end

def solveLine(line, f) do
  pairTargetsWithValues(line)
    |> Enum.flat_map(fn pair -> solvePair(f, pair) end)
end

def solveRow(row) do
  solveLine(row, fn x -> x.across end)
end

def solveColumn(column) do
  solveLine(column, fn x -> x.down end)
end

def solveGrid(grid) do
  rowsDone = grid |> Enum.map(fn r -> solveRow(r) end)
  colsDone = transpose(rowsDone)
    |> Enum.map(fn col -> solveColumn(col) end)
  transpose(colsDone)
end

def drawGrid(grid) do
  (grid |> Enum.map(fn row -> drawRow(row) end) |> Enum.join()) <> "\n"
end

def solver(grid) do
  IO.puts drawGrid(grid)
  g = solveGrid(grid)
  if g == grid do
    g
  else
    solver(g)
  end
end

end

