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
    IO.puts result
    assert "    3\\ 4   123456789 12.......    4\\--     -----     --\\ 5       4         1    \n" == result
  end

  test "permute" do
    vs = [v(), v(), v()]
    results = permuteAll(vs, 6)
    IO.puts results
    assert 10 == results.length()
    diff = results |> Enum.filter(fn p -> allDifferent(p) end)
    assert 6 == diff.length
  end

end
