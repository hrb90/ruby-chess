class Piece
  SYMBOL = "P"

  def initialize(color)
    @color = color
  end

  def to_s
    SYMBOL
  end

  def empty?
    false
  end
end

class NullPiece < Piece
  include Singleton

  def empty?
    true
  end

  def moves
    []
  end
end

module Slidable

end

module Steppable

end

class Rook < Piece
  include Slidable
end

class Bishop < Piece
  include Slidable
end

class Queen < Piece
  include Slidable
end

class Knight < Piece
end

class King < Piece
end

class Pawn < Piece
end
