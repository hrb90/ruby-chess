require_relative 'steppable'
require_relative 'piece'

class King < Piece
  include Steppable

  protected

  def symbol
    "♔"
  end

  private

  def move_dirs
    BISHOP_DIRS + ROOK_DIRS
  end
end
