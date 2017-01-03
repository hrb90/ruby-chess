require_relative 'slidable'
require_relative 'piece'

class Queen < Piece
  include Slidable

  protected

  def symbol
    "Q"
  end

  private

  def move_dirs
    BISHOP_DIRS + ROOK_DIRS
  end
end
