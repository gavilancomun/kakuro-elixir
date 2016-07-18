defmodule KakuroTest do
use ExUnit.Case
doctest Kakuro

import Kakuro

test "the truth" do
  assert 1 + 1 == 2
end

test "draw row" do
  line = [da(3, 4), v(), v([1, 2]), d(4), e(), a(5), v([4]), v([1])]
  result = drawRow(line)
  IO.inspect result
  assert "    3\\ 4   123456789 12.......    4\\--     -----     --\\ 5       4         1    \n" == result
end

test "permute" do
  vs = [v(), v(), v()]
  results = permuteAll(vs, 6)
  IO.inspect results
  assert 10 == length(results)
  diff = results |> Enum.filter(fn p -> allDifferent(p) end)
  assert 6 == length(diff)
end

test "transpose" do
  ints = [[1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4]]
  tr = transpose(ints)
  IO.inspect ints
  IO.inspect tr
  assert length(ints) == length(Enum.at(tr, 0))
  assert length(Enum.at(ints, 0)) == length(tr)
end

test "takewhile" do
  result = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] |> Enum.take_while(fn n -> n < 4 end)
  IO.inspect result
  assert 4 == length(result)
end

test "concat" do
  a = [1, 2, 3]
  b = [4, 5, 6, 1, 2, 3]
  result = a ++ b
  IO.inspect result 
  assert 9 == length(result)
end

test "drop" do
  a = [1, 2, 3, 4, 5, 6]
  result = a |> Enum.drop(4)
  IO.inspect result
  assert 2 == length(result)
end

test "take" do
  a = [1, 2, 3, 4, 5, 6]
  result = a |> Enum.take(4)
  IO.inspect result
  assert 4 == length(result)
end

test "partby" do
  data = [1, 2, 2, 2, 3, 4, 5, 5, 6, 7, 7, 8, 9]
  result = partitionBy(fn n -> 0 == rem(n, 2) end, data)
  IO.inspect result
  assert 9 == length(result)
end

test "partall" do
  data = [1, 2, 2, 2, 3, 4, 5, 5, 6, 7, 7, 8, 9]
  result = partitionAll(5, 3, data)
  IO.inspect result
  assert 5 == length(result)
end

test "partn" do
  data = [1, 2, 2, 2, 3, 4, 5, 5, 6, 7, 7, 8, 9]
  result = partitionN(5, data)
  IO.inspect result
  assert 3 == length(result)
end

test "last" do
  data = [1, 2, 3]
  result = List.last(data)
  assert 3 == result
end

test "solvestep" do
  result = solveStep([v([1, 2]), v()], 5)
  IO.puts "solve step result "
  IO.inspect result
  assert v([1, 2]) == result |> Enum.at(0)
  assert v([3, 4]) == result |> Enum.at(1)
end

test "gather" do
  line = [da(3, 4), v(), v(), d(4), e(), a(4), v(), v()]
  result = gatherValues(line)
  IO.puts "gather "
  IO.inspect result
  assert 4 == length(result)
  assert da(3, 4) == result |> Enum.at(0) |> Enum.at(0)
  assert d(4) == result |> Enum.at(2) |> Enum.at(0)
  assert e() == result |> Enum.at(2) |> Enum.at(1)
  assert a(4) == result |> Enum.at(2) |> Enum.at(2)
end

test "pairtargets" do
  line = [da(3, 4), v(), v(), d(4), e(), a(4), v(), v()]
  result = pairTargetsWithValues(line)
  IO.puts "pair "
  IO.inspect result
  assert 2 == length(result)
  assert da(3, 4) == result |> Enum.at(0) |> Enum.at(0) |> Enum.at(0)
  assert d(4) == result |> Enum.at(1) |> Enum.at(0) |> Enum.at(0)
  assert e() == result |> Enum.at(1) |> Enum.at(0) |> Enum.at(1)
  assert a(4) == result |> Enum.at(1) |> Enum.at(0) |> Enum.at(2)
end

test "solvepair" do
  line = [da(3, 4), v(), v(), d(4), e(), a(4), v(), v()]
  pairs = pairTargetsWithValues(line)
  pair = pairs |> Enum.at(0)
  result = solvePair(fn cell -> cell.down end, pair)
  IO.puts "solvePair "
  IO.inspect result
  assert 3 == length(result)
  assert v([1, 2]) == result |> Enum.at(1)
  assert v([1, 2]) == result |> Enum.at(2)
end

test "solveline" do
  line = [da(3, 4), v(), v(), d(4), e(), a(5), v(), v()]
  result = solveLine(line, fn v -> solvePair(fn x -> x.across end, v) end)
  IO.puts "solve line "
  IO.inspect result
  assert 8 == length(result)
  assert v([1, 3]) == result |> Enum.at(1)
  assert v([1, 3]) == result |> Enum.at(2)
  assert v([1, 2, 3, 4]) == result |> Enum.at(6)
  assert v([1, 2, 3, 4]) == result |> Enum.at(7)
end

test "row" do
  result = solveRow([a(3), v([1, 2, 3]), v([1])])
  IO.puts "solve row "
  IO.inspect result
  assert v([2]) == result |> Enum.at(1)
  assert v([1]) == result |> Enum.at(2)
end

test "col" do
  result = solveColumn([da(3, 12), v([1, 2, 3]), v([1])])
  IO.puts "solve col "
  IO.inspect result
  assert v([2]) == result |> Enum.at(1)
  assert v([1]) == result |> Enum.at(2)
end

test "grid" do
  grid1 = [
    [e(), d(4), d(22), e(), d(16), d(3)],
    [a(3), v(), v(), da(16, 6), v(), v()],
    [a(18), v(), v(), v(), v(), v()],
    [e(), da(17, 23), v(), v(), v(), d(14)],
    [a(9), v(), v(), a(6), v(), v()],
    [a(15), v(), v(), a(12), v(), v()]]
  result = solver(grid1)
  assert "   --\\ 3       1         2       16\\ 6       4         2    \n" == drawRow(result |> Enum.at(1))
  assert "   --\\18       3         5         7         2         1    \n" == drawRow(result |> Enum.at(2))
  assert "   -----     17\\23       8         9         6       14\\--  \n" == drawRow(result |> Enum.at(3))
  assert "   --\\ 9       8         1       --\\ 6       1         5    \n" == drawRow(result |> Enum.at(4))
  assert "   --\\15       9         6       --\\12       3         9    \n" == drawRow(result |> Enum.at(5))
end

end
