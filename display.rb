require 'byebug'
require 'colorize'
require_relative 'board'
require_relative 'cursor'

class Display
  attr_reader :board, :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end

  def get_move
    positions = []
    until positions.length == 2
      render
      input = cursor.get_input
      positions << input unless input.nil?
      system "clear"
    end
    positions
  end

  def interact
    while true
      render
      cursor.get_input
      system "clear"
    end
  end

  def render
    (0..7).each do |rank|
      render_rank = ""
      (0..7).each do |file|
        piece = board[[rank, file]]
        render_piece = piece.to_s
        if [rank, file] == cursor.cursor_pos
          render_piece = render_piece.colorize(:background => :light_green)
        end
        render_rank << render_piece
      end
      puts render_rank
    end
  end
end
