require_relative 'board'
require 'byebug'
require 'colorize'
require 'yaml'

class Minesweeper

  def self.load_from_file(filename)
    self.new(YAML::load(File.open(filename)))
  end


  def initialize(board = nil, n = 9)
    if board.nil?
      @board = Board.new(n)
    else
      @board = board
    end
  end

  def play
    puts "Minesweeper".colorize(:red)
    until game_over?
      board.render
      action = get_user_input_action
      next if check_for_save?(action)
      coords = get_user_input_coords

      system("clear")
      make_play(action, coords)
    end

    print_end_message
  end

  private
  attr_reader :board

  def check_for_save?(action)
    return false unless action == "s"
    print "saving game to what filename? "
    filename = STDIN.gets.chomp
    data = board.to_yaml
    File.open("#{filename}", "w") do |f|
      f.puts data
    end

    true
  end

  def game_over?
    board.game_over?
  end

  def get_user_input_action
    action = nil
    until action && (action == "f" || action == "r" || action == "s")
      print "Please state your action: (f)lag, (r)eveal, (s)ave: "
      action = STDIN.gets.chomp
    end

    action
  end

  def get_user_input_coords
    row, col = nil, nil

    until (0..9).cover?(row) && (0..9).cover?(col)
      print "Please enter a coordinate [row, col]: "
      coords = STDIN.gets.chomp
      /(?<row>\d)\D(?<col>\d)/ =~ coords
      row, col = row.to_i, col.to_i
    end

    [row, col]
  end

  def make_play(action, coords)
    @board.make_play(action, coords)
  end

  def print_end_message
    board.render
    if board.explosion
      puts "Sorry. You were killed by a mine.".colorize(:red)
    else
      puts "Congratulations! You have saved cows from certain demise."
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  if ARGV.empty?
    Minesweeper.new.play
  else
    Minesweeper.load_from_file(ARGV[0]).play
  end
end
