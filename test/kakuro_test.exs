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
end
