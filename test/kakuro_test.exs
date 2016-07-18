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
  assert "    3\\ 4   123456789 12.......    4\\--     -----     --\\ 5       4         1    \n" == result
end

test "permute" do
  vs = [v(), v(), v()]
  results = permuteAll(vs, 6)
  assert 10 == length(results)
  diff = results |> Enum.filter(fn p -> allDifferent(p) end)
  assert 6 == length(diff)
end

test "transpose" do
  ints = [[1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4]]
  tr = transpose(ints)
  assert length(ints) == length(Enum.at(tr, 0))
  assert length(Enum.at(ints, 0)) == length(tr)
end

test "takewhile" do
  result = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] |> Enum.take_while(fn n -> n < 4 end)
  assert 4 == length(result)
end

test "concat" do
  a = [1, 2, 3]
  b = [4, 5, 6, 1, 2, 3]
  result = a ++ b
  assert 9 == length(result)
end

test "drop" do
  a = [1, 2, 3, 4, 5, 6]
  result = a |> Enum.drop(4)
  assert 2 == length(result)
end

test "take" do
  a = [1, 2, 3, 4, 5, 6]
  result = a |> Enum.take(4)
  assert 4 == length(result)
end

test "partby" do
  data = [1, 2, 2, 2, 3, 4, 5, 5, 6, 7, 7, 8, 9]
  result = partitionBy(fn n -> 0 == rem(n, 2) end, data)
  assert 9 == length(result)
end

test "partall" do
  data = [1, 2, 2, 2, 3, 4, 5, 5, 6, 7, 7, 8, 9]
  result = partitionAll(5, 3, data)
  assert 5 == length(result)
end

test "partn" do
  data = [1, 2, 2, 2, 3, 4, 5, 5, 6, 7, 7, 8, 9]
  result = partitionN(5, data)
  assert 3 == length(result)
end

test "solvestep" do
  result = solveStep([v([1, 2]), v()], 5)
  assert v([1, 2]) == result |> Enum.at(0)
  assert v([3, 4]) == result |> Enum.at(1)
end

end
