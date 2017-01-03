require_relative 'steppable'
require_relative 'piece'

class Knight < Piece
  include Steppable

  protected

  def symbol
    "N"
  end

  private

  def move_dirs
    KNIGHT_DIRS
  end
end
