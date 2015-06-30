require 'colorize'

class Tile
  attr_reader :bomb, :revealed
  attr_accessor :count, :flagged

  def initialize (count = :B)
    @count = count
    @revealed = false
    @flagged = false
    @bomb = false
  end

  def bomb?
    bomb
  end

  def flag
    flagged ? self.flagged = false : self.flagged = true
  end

  def reveal
    self.revealed = true
  end

  def revealed?
    revealed
  end

  def set_bomb
    @bomb = true
  end

  def to_s
    if flagged
      "F".colorize(:yellow)
    elsif !revealed
      "*"
    elsif revealed && bomb
      "X".colorize(:red)
    else
      count == 0 ? (return " ") : (return "#{count}".colorize(:blue))
    end
  end

  private
  attr_writer :revealed
end
