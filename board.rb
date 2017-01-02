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
    if self[start_pos].is_a?(Piece)
      self[end_pos], self[start_pos] = self[start_pos], nil
    else
      raise StandardError.new("Oops, there's no piece there!")
    end
  end

  def in_bounds?(pos)
    pos.all? { |x| x >= 0 && x < 8 }
  end

  private

  attr_reader :grid

  # this will get way more complicated
  def setup_board
    [0,1,6,7].each do |rank|
      (0..7).to_a.each do |file|
        grid[rank][file] = Piece.new
      end
    end
  end
end
