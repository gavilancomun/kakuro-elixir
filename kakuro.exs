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
  case Set.member?(x, values) do
    true -> Integer.to_string(x);
    _ -> "."
  end
end

def draw({empty}) do "   -----  " end
def draw({down, N}) do :io_lib.format("   ~2B\\--  ", [N]) end
def draw({across, N}) do :io_lib.format("   --\\~2B  ", [N]) end
def draw({down_across, D, A}) do :io_lib.format("   ~2B\\~2B  ", [D, A]) end
def draw({value, Values}) do 
  case Set.size(Values) == 1 do
    true -> Enum.reduce(["     " ++ Integer.to_string(X) ++ "    " || X <- Set.to_list(Values)], fn(v, acc) -> acc ++ v end )
    _ -> " " ++ Enum.reduce([ draw_v(Values, X) || X <- [1, 2, 3, 4, 5, 6, 7, 8, 9]], fn (v, acc) -> acc ++ v end)
  end
end

def main() do
  :ok
end

end


Kakuro.main()

