require 'byebug'
require 'colorize'
require_relative 'board'
require_relative 'cursor'

class Display
  attr_reader :board, :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
    @highlighted = false
  end

  def get_move
    positions = []
    until positions.length == 2
      render
      input = cursor.get_input
      return input if is_castle?(input)
      unless input.nil?
        positions << input
        @highlighted = true
      end
      system "clear"
    end
    @highlighted = false
    positions
  end

  def render
    puts "Return to select a start and ending position"
    puts "K to castle kingside, Q to castle queenside"
    (0..7).each do |rank|
      render_rank = ""
      (0..7).each do |file|
        piece = board[[rank, file]]
        bg_color = get_background(rank, file)
        render_piece = piece.to_s.colorize(:background => bg_color)
        render_rank << render_piece
      end
      puts render_rank
    end
  end

  private

  def get_background(rank, file)
    if [rank, file] == cursor.cursor_pos
      @highlighted ? :light_red : :red
    elsif (rank + file) % 2 == 0
      return :light_green
    else
      return :green
    end
  end

  def is_castle?(input)
    [:kingside, :queenside].include?(input)
  end
end
