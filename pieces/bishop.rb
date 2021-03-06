require_relative 'slidable'
require_relative 'piece'

class Bishop < Piece
  include Slidable

  protected

  def symbol
    color == :white ? "♗" : "♝"
  end

  private

  def move_dirs
    BISHOP_DIRS
  end
end
