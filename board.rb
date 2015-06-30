require_relative 'tile'
require 'colorize'

class Board
  attr_reader :grid, :explosion

  def initialize(num = 9)
    @grid = Array.new(num) { Array.new(num) {Tile.new(nil)} }
    @explosion = false
    populate
    set_tile_values
  end

  def game_over?
    lost? || won?
  end

  def lost?
    explosion
  end

  def won?
    (0...grid.length).each do |r|
      (0...(@grid[0].length)).each do |c|
        unless self[r, c].bomb? || self[r, c].revealed?
          return false
        end
      end
    end

    true
  end


  def make_play(action, coords)
    if action == "r"
      if self[*coords].revealed?
        puts "invalid selection. #{coords} has been revealed already".colorize(:red)
      else
        reveal(coords)
      end
    elsif action == "f"
      self[*coords].flag
    end
  end

  def render
    puts (0...@grid[0].length).to_a.insert(0," ").join(" ")
    @grid.each_with_index do |row,idx|
      puts row.map(&:to_s).insert(0,idx).join("|")
    end

    nil
  end

  private
  attr_writer :explosion

  NEIGHBORS = [-1, 0, 1].repeated_permutation(2).to_a

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, value)
    @grid[row][col] = value
  end

  def get_neighboring_spaces(pos)
    NEIGHBORS.map{|npos| [npos[0]+pos[0], npos[1]+pos[1]]}
  end

  def populate
    tiles.sample(10).each do |tile|
      tile.set_bomb
    end
  end

  def tiles
    @grid.flatten
  end

  def reveal(pos)
    self[*pos].reveal
    if self[*pos].bomb?
      self.explosion = true
    else
      reveal_neighbors(pos) if self[*pos].count == 0
    end
  end

  def reveal_neighbors(pos)
    neighboring_spaces = get_neighboring_spaces(pos)
    neighboring_spaces.each do |next_pos|
      reveal(next_pos) if within_board?(next_pos) && !self[*next_pos].revealed?
    end
  end

  def set_tile_values
    (0...grid.length).each do |r|
      (0...(@grid[0].length)).each do |c|
        next if self[r, c].bomb?
        neighboring_spaces = get_neighboring_spaces([r,c])
        bomb_count = neighboring_spaces.select do |pos|
          within_board?(pos) && self[*pos].bomb?
        end.count
        self[r, c].count = bomb_count
      end
    end
  end

  def within_board?(coords)
    coords[0].between?(0, grid.length-1) &&
    coords[1].between?(0, grid[0].length-1)
  end
end
