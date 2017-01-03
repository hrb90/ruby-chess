require 'colorize'
require 'singleton'

class Piece
  attr_reader :color, :pos

  def initialize(board, pos, color = nil)
    @board = board
    @pos = pos
    @color = color
  end

  def to_s
    symbol
  end

  def empty?
    false
  end

  def set_pos(pos)
    @pos = pos
  end

  def valid_moves
    moves.reject { |end_pos| move_into_check?(end_pos) }
  end

  protected

  attr_reader :board

  def symbol
    "X"
  end

  private

  BISHOP_DIRS = [[1,1],
       [1,-1],
       [-1,1],
       [-1,-1]]

  ROOK_DIRS = [[0,1],
       [0,-1],
       [1,0],
       [-1,0]]

  KNIGHT_DIRS = [[1,2],
       [1,-2],
       [2,1],
       [2,-1],
       [-1,2],
       [-1,-2],
       [-2,1],
       [-2,-1]]

  def move_into_check?(end_pos)
    dup_board = board.dup
    dup_board.move_piece!(pos, end_pos)
    dup_board.in_check?(color)
  end
end

class NullPiece < Piece
  include Singleton

  def initialize
    @color = nil
  end

  def empty?
    true
  end

  def moves
    []
  end

  protected

  def symbol
    " "
  end
end
