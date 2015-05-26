defmodule Kakuro do 

def e() do
  {:empty}
end

def a(across) do
  {:across, across}
end

def d(down) do
  {:down, down}
end

def da(down, across) do
  {:down_across, down, across}
end

def v() do
  {:value, Enum.into([1, 2, 3, 4, 5, 6, 7, 8, 9], HashSet.new)}
end

def v(values) do
  {:value, Enum.into(values, HashSet.new)}
end

def draw_v(values, x) do
  case Set.member?(values, x) do
    true -> Integer.to_string(x);
    _ -> "."
  end
end

def catstr(coll) do
  Enum.reduce(coll, fn (v, acc) -> acc <> v end)
end

def draw({:empty}) do "   -----  " end
def draw({:down, n}) do :io_lib.format("   ~2B\\--  ", [n]) |> List.flatten |> to_string end
def draw({:across, n}) do :io_lib.format("   --\\~2B  ", [n]) |> List.flatten |> to_string end
def draw({:down_across, d, a}) do :io_lib.format("   ~2B\\~2B  ", [d, a]) |> List.flatten |> to_string end
def draw({:value, values}) do 
  case Set.size(values) == 1 do
    true -> catstr(for x <- Set.to_list(values), do: "     " <> Integer.to_string(x) <> "    ")
    _ -> " " <> catstr(for x <- [1, 2, 3, 4, 5, 6, 7, 8, 9], do: draw_v(values, x))
  end
end

def draw_row(row) do
  catstr(for x <- row, do: draw(x)) <> "\n"
end

def draw_grid(grid) do
  "\n" <> catstr(for x <- grid, do: draw_row(x))
end

def transpose([[]|_]) do [] end
def transpose(m) do
  [Enum.map(m, &hd/1) | transpose(Enum.map(m, &tl/1))]
end

def grid1() do 
  [[e(), d(4), d(22), e(), d(16), d(3)],
   [a(3), v(), v(), da(16, 6), v(), v()],
   [a(18), v(), v(), v(), v(), v()],
   [e(), da(17, 23), v(), v(), v(), d(14)],
   [a(9), v(), v(), a(6), v(), v()],
   [a(15), v(), v(), a(12), v(), v()]]
end

def main() do
  IO.puts draw(e())
  IO.puts draw(a(12))
  IO.puts draw(d(12))
  IO.puts draw(da(12, 6))
  IO.puts draw(v())
  IO.puts draw(v([1, 3, 7]))
  IO.puts draw_grid(grid1())
  IO.puts (grid1() |> transpose |> draw_grid)
  :ok
end

end

Kakuro.main()

