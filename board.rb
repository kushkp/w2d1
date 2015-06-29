class Board
  def initialize(num = 9)
    @grid = Array.new(num) { Array.new(num) {:*} }
    @bombs = []

  end


  def populate
    until @bombs.size >= 10
      pos = [rand(@grid.size), rand(@grid.size)]
      bombs << pos unless bombs.include?(pos)
    end

    #bomb locations on grid
    # @bombs.each do |pos|
    #   self[*pos] =
    # end
  end

  def reveal(pos)
    if bombs.include?(pos)
      game_over
    else
      reveal_neighbors(pos)
    end
  end

  def reveal_neighbors(pos)
    neighboring_spaces = NEIGHBORS.map{|npos| [npos[0]+pos[0], npos[0]+pos[0]]}
    count = (neighboring_spaces & bombs).count
    if count > 0
      self[*pos] = Tile.new(count)
    else
      neighboring_spaces.map{|pos| reveal(pos)}
    end
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, value)
    @grid[row][col] = value
  end

  private
  attr_accessor :bombs

  NEIGHBORS = [-1,0,1].repeated_permutation(2).to_a
end
