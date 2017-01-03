require 'byebug'
require 'require_all'
require_all 'pieces'
require_relative 'chess_exception'

class Board
  PIECE_ROW = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

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

  def move_piece!(start_pos, end_pos)
    self[start_pos].set_pos(end_pos)
    self[end_pos].set_pos(nil) unless self[end_pos].empty?
    self[end_pos], self[start_pos] = self[start_pos], NullPiece.instance
  end

  def move_piece(start_pos, end_pos)
    if self[start_pos].valid_moves.include?(end_pos)
      move_piece!(start_pos, end_pos)
    else
      raise ChessException.new("Not a valid move!")
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

  def dup
    new_board = Board.new
    new_grid = grid.map do |rank|
      rank.map { |piece| dup_piece(piece, new_board) }
    end
    new_board.grid = new_grid
    new_board
  end

  def dup_piece(piece, new_board)
    return piece if piece.empty?

    piece.class.new(new_board, piece.pos, piece.color)
  end

  def checkmate?(color)
    in_check?(color) && grid.flatten.none? do |piece|
      piece.valid_moves.any? && piece.color == color
    end
  end

  def over?
    checkmate?(:white) || checkmate?(:black)
  end

  protected

  attr_accessor :grid

  private

  def find_king(color)
    grid.flatten.find { |piece| piece.is_a?(King) && piece.color == color }.pos
  end

  def setup_board
    setup_pieces(0, :black)
    setup_pieces(7, :white)
    setup_pawns
    setup_null
  end

  def setup_pieces(rank, color)
    PIECE_ROW.each_with_index do |klass, file|
      self[[rank, file]] = klass.new(self, [rank, file], color)
    end
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
