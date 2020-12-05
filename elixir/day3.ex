defmodule Day3 do
  # Sets initial values
  def p1(lines, over, down) do
    p1(lines, over, down - 1, 0, 0, 0)
  end

  # Skip line if we haven't gone down enough
  def p1([_ | lines], over, skip, prev_x, cur_y, encounters) when cur_y > 0 do
    p1(lines, over, skip, prev_x, cur_y - 1, encounters)
  end

  # Recursively find the number of tree encounters
  def p1([line | lines], over, skip, prev_x, cur_y, encounters) when cur_y == 0 do
    cur_x = Integer.mod(prev_x + over, String.length(line))
    case String.at(line, cur_x) do
      "#" -> p1(lines, over, skip, cur_x, skip, encounters + 1)
      "." -> p1(lines, over, skip, cur_x, skip, encounters)
      c -> raise "Invalid character '" <> c <> "'"
    end
  end

  # Stop when there are no more lines to process
  def p1(lines, _, _, _, _, encounters) when length(lines) == 0, do: encounters

  def p2(lines, slopes, product \\ 1)

  # Computes the product of p1 for each slope
  def p2(lines, [slope | slopes], product) do
    encounters = p1(lines, Enum.at(slope, 0), Enum.at(slope, 1))
    IO.puts(Integer.to_string(encounters))
    p2(lines, slopes, product * encounters)
  end

  # Stop when there are no more slopes
  def p2(_, slopes, product) when length(slopes) == 0, do: product

  # Read each line into a list
  def get_lines(lines \\ []) do
    line = IO.gets("")
    line = String.slice(line, 0, String.length(line) - 1)
    case String.length(line) do
      0 -> lines
      _ -> get_lines(lines ++ [line])
    end
  end

  def run do
    lines = get_lines()
    slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
    IO.puts(Integer.to_string(p2(lines, slopes)))
  end
end
