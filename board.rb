require 'byebug'
require_relative 'pieces'

class Board
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    setup_board
  end

  def [](pos)
    rank, file = pos
    grid[rank][file]
  end

  def []=(pos, val)
    rank, file = pos
    grid[rank][file] = val
  end

  def move_piece(start_pos, end_pos)
    if self[start_pos].moves.include?(end_pos)
      self[start_pos].set_pos(end_pos)
      self[end_pos].set_pos(nil) unless self[end_pos].empty?
      self[end_pos], self[start_pos] = self[start_pos], NullPiece.instance
    else
      raise StandardError.new("Not a valid move!")
    end
  end

  def in_bounds?(pos)
    pos.all? { |x| x >= 0 && x < 8 }
  end

  def in_check?(color)
    king_pos = find_king(color)

    grid.flatten.any? do |piece|
      piece.moves.include?(king_pos) && piece.color != color
    end
  end

  # def checkmate?(color)
  #   in_check?(color) && grid.flatten.none? do |piece|
  #     piece.valid_moves.any?
  #   end
  # end

  private

  attr_reader :grid

  def find_king(color)
    grid.flatten.find { |piece| piece.is_a?(King) && piece.color == color }.pos
  end

  def setup_board
    setup_kings
    setup_queens
    setup_bishops
    setup_knights
    setup_rooks
    setup_pawns
    setup_null
  end

  def setup_kings
    self[[0,4]] = King.new(self, [0,4], :black)
    self[[7,4]] = King.new(self, [7,4], :white)
  end

  def setup_queens
    self[[0,3]] = Queen.new(self, [0,3], :black)
    self[[7,3]] = Queen.new(self, [7,3], :white)
  end

  def setup_bishops
    self[[0,2]] = Bishop.new(self, [0,2], :black)
    self[[0,5]] = Bishop.new(self, [0,5], :black)
    self[[7,2]] = Bishop.new(self, [7,2], :white)
    self[[7,5]] = Bishop.new(self, [7,5], :white)
  end

  def setup_knights
    self[[0,1]] = Knight.new(self, [0,1], :black)
    self[[0,6]] = Knight.new(self, [0,6], :black)
    self[[7,1]] = Knight.new(self, [7,1], :white)
    self[[7,6]] = Knight.new(self, [7,6], :white)
  end

  def setup_rooks
    self[[0,0]] = Rook.new(self, [0,0], :black)
    self[[0,7]] = Rook.new(self, [0,7], :black)
    self[[7,0]] = Rook.new(self, [7,0], :white)
    self[[7,7]] = Rook.new(self, [7,7], :white)
  end

  def setup_pawns
    (0..7).to_a.each do |file|
      self[[1, file]] = Pawn.new(self, [1, file], :black)
      self[[6, file]] = Pawn.new(self, [6, file], :white)
    end
  end

  def setup_null
    (2..5).to_a.each do |rank|
      (0..7).to_a.each do |file|
        self[[rank, file]] = NullPiece.instance
      end
    end
  end

end
