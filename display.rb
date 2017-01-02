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

  def interact
    while true
      render
      cursor.get_input
      system "clear"
    end
  end

  def render
    (0..7).to_a.each do |rank|
      render_rank = ""
      (0..7).to_a.each do |file|
        square = board[[rank, file]]
        render_piece = square.to_s
        if [rank, file] == cursor.cursor_pos
          render_piece = render_piece.colorize(:background => :light_green)
        end
        render_rank << render_piece
      end
      puts render_rank
    end
  end
end
