require_relative 'slidable'
require_relative 'piece'

class Rook < Piece
  include Slidable

  protected

  def symbol
    "R"
  end

  private

  def move_dirs
    ROOK_DIRS
  end
end
