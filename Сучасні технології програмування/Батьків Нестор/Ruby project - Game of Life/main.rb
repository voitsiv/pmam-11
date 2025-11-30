rows = 15
cols = 30
grid = Array.new(rows) { Array.new(cols) { rand(2) } }

def print_grid(g)
  system("clear") rescue system("cls")

  puts "+" + "-" * g[0].length + "+"

  g.each do |row|
    line = row.map { |c| c == 1 ? "■" : " " }.join
    puts "|" + line + "|"
  end

  puts "+" + "-" * g[0].length + "+"

  sleep 0.2
end

def next_gen(g)
  r = g.length
  c = g[0].length
  new = Array.new(r) { Array.new(c, 0) }
  dirs = [-1, 0, 1]

  (0...r).each do |i|
    (0...c).each do |j|
      neighbors = 0
      dirs.each do |a|
        dirs.each do |b|
          next if a == 0 && b == 0
          x = i + a
          y = j + b
          neighbors += 1 if x >= 0 && y >= 0 && x < r && y < c && g[x][y] == 1
        end
      end

      if g[i][j] == 1
        new[i][j] = 1 if neighbors == 2 || neighbors == 3
      else
        new[i][j] = 1 if neighbors == 3
      end
    end
  end

  new
end

while true
  print_grid(grid)
  grid = next_gen(grid)
end
