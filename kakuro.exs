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

def draw({:empty}) do "   -----  " end
def draw({:down, n}) do :io_lib.format("   ~2B\\--  ", [n]) end
def draw({:across, n}) do :io_lib.format("   --\\~2B  ", [n]) end
def draw({:down_across, d, a}) do :io_lib.format("   ~2B\\~2B  ", [d, a]) end
def draw({:value, values}) do 
  case Set.size(values) == 1 do
    true -> Enum.reduce((for x <- Set.to_list(values), do: "     " <> Integer.to_string(x) <> "    "), fn(v, acc) -> acc <> v end )
    _ -> " " <> Enum.reduce((for x <- [1, 2, 3, 4, 5, 6, 7, 8, 9], do: draw_v(values, x)), fn (v, acc) -> acc <> v end)
  end
end

def main() do
  IO.puts draw(e());
  IO.puts draw(a(12));
  IO.puts draw(d(12));
  IO.puts draw(da(12, 6));
  IO.puts draw(v());
  IO.puts draw(v([1, 3, 7]));
  :ok
end

end


Kakuro.main()

