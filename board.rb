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

  def move_piece!(start_pos, end_pos)
    self[start_pos].set_pos(end_pos)
    self[end_pos].set_pos(nil) unless self[end_pos].empty?
    self[end_pos], self[start_pos] = self[start_pos], NullPiece.instance
  end

  def move_piece(start_pos, end_pos)
    if self[start_pos].valid_moves.include?(end_pos)
      move_piece!(start_pos, end_pos)
      update_castling_data
    else
      raise ChessException.new("Not a valid move!")
    end
  end

  def in_bounds?(pos)
    pos.all? { |x| x >= 0 && x < 8 }
  end

  def in_check?(color)
    is_threatened?(find_king(color), color)
  end

  def dup
    new_board = Board.new
    new_grid = grid.map do |rank|
      rank.map { |piece| dup_piece(piece, new_board) }
    end
    new_board.grid = new_grid
    new_board
  end

  def checkmate?(color)
    in_check?(color) && grid.flatten.none? do |piece|
      piece.valid_moves.any? && piece.color == color
    end
  end

  def over?
    checkmate?(:white) || checkmate?(:black)
  end

  def castle(side, color)
    raise ChessException.new("Can't castle!") unless can_castle(side, color)
    rank = color == :white ? 7 : 0
    if side == :queenside
      move_piece!([rank, 4], [rank, 2])
      move_piece!([rank, 0], [rank, 3])
    else
      move_piece!([rank, 4], [rank, 6])
      move_piece!([rank, 7], [rank, 5])
    end
  end

  def can_castle(side, color)
    pieces_can_castle(side, color) &&
     castling_spaces_empty(side, color) &&
     castling_spaces_unthreatened(side, color)
  end

  protected

  attr_accessor :grid

  private

  def []=(pos, val)
    rank, file = pos
    grid[rank][file] = val
  end

  def find_king(color)
    grid.flatten.find { |piece| piece.is_a?(King) && piece.color == color }.pos
  end

  def is_threatened?(pos, color)
    grid.flatten.any? do |piece|
      piece.moves.include?(pos) && piece.color != color
    end
  end

  def dup_piece(piece, new_board)
    return piece if piece.empty?

    piece.class.new(new_board, piece.pos, piece.color)
  end

  def init_castling_data
    @king_can_castle = {
      white: true,
      black: true
    }
    @rook_can_castle = {
      white: {
        queenside: true,
        kingside: true
      },
      black: {
        queenside: true,
        kingside: true
      }
    }
  end

  def update_castling_data
    [:white, :black].each do |color|
      rank = color == :white ? 7 : 0
      @king_can_castle[color] = false unless self[[rank, 4]].is_a?(King)
      [:queenside, :kingside].each do |side|
        file = side == :kingside ? 7 : 0
        unless self[[rank, file]].is_a?(Rook) && self[[rank, file]].color == color
          @rook_can_castle[color][side] = false
        end
      end
    end
  end

  def pieces_can_castle(side, color)
    @king_can_castle[color] && @rook_can_castle[color][side]
  end

  def castling_spaces_empty(side, color)
    rank = color == :white ? 7 : 0
    files = side == :kingside ? [5, 6] : [1, 2, 3]
    files.all? { |file| self[[rank, file]].empty? }
  end

  def castling_spaces_unthreatened(side, color)
    rank = color == :white ? 7 : 0
    files = side == :kingside ? [5, 6] : [2, 3]
    files.none? { |file| is_threatened?([rank, file], color) }
  end

  def setup_board
    setup_pieces(0, :black)
    setup_pieces(7, :white)
    setup_pawns
    setup_null
    init_castling_data
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
