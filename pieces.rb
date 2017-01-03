require 'colorize'
require 'singleton'

class Piece
  attr_reader :color

  def initialize(board, pos, color = nil)
    @board = board
    @pos = pos
    @color = color
  end

  def to_s
    symbol.colorize(@color).colorize(:background => :red)
  end

  def empty?
    false
  end

  def set_pos(pos)
    @pos = pos
  end

  protected

  attr_reader :pos, :board

  def symbol
    "X"
  end
end

class NullPiece < Piece
  include Singleton

  def initialize
    @color = nil
  end

  def empty?
    true
  end

  def moves
    []
  end

  protected

  def symbol
    " "
  end
end

module Movable
  def add_direction(pos, direction)
    r, f = pos
    dr, df = direction
    [r + dr, f + df]
  end
end

module Slidable
  include Movable

  def moves
    moves = []
    move_dirs.each do |dir|
      current_pos = add_direction(pos, dir)
      while board.in_bounds?(current_pos)
        if board[current_pos].empty?
          moves << current_pos
        else
          # capture if the piece on current_pos is the opposite color
          # either way we can't slide past it
          moves << current_pos unless board[current_pos].color == color
          break
        end
        current_pos = add_direction(current_pos, dir)
      end
    end
    moves
  end
end

module Steppable
  include Movable

  def moves
    moves = []
    move_dirs.each do |dir|
      new_pos = add_direction(pos, dir)
      moves << new_pos if board.in_bounds?(new_pos) && board[new_pos].color != color
    end
    moves
  end
end

class Rook < Piece
  include Slidable

  protected

  def symbol
    "R"
  end

  private

  def move_dirs
    [[0,1],
     [0,-1],
     [1,0],
     [-1,0]]
  end
end

class Bishop < Piece
  include Slidable

  protected

  def symbol
    "B"
  end

  private

  def move_dirs
    [[1,1],
     [1,-1],
     [-1,1],
     [-1,-1]]
  end
end

class Queen < Piece
  include Slidable

  protected

  def symbol
    "Q"
  end

  private

  def move_dirs
    [[0,1],
     [0,-1],
     [1,0],
     [-1,0],
     [1,1],
     [1,-1],
     [-1,1],
     [-1,-1]]
  end
end

class Knight < Piece
  include Steppable

  protected

  def symbol
    "N"
  end

  private

  def move_dirs
    [[1,2],
     [1,-2],
     [2,1],
     [2,-1],
     [-1,2],
     [-1,-2],
     [-2,1],
     [-2,-1]]
  end
end

class King < Piece
  include Steppable

  protected

  def symbol
    "K"
  end

  private

  def move_dirs
    [[0,1],
     [0,-1],
     [1,0],
     [-1,0],
     [1,1],
     [1,-1],
     [-1,1],
     [-1,-1]]
  end
end

class Pawn < Piece
  include Movable

  def moves
    moves = []
    # add the forward moves
    push_one = add_direction(pos, forward)
    if board.in_bounds?(push_one) && board[push_one].empty?
      moves << push_one
      push_two = add_direction(push_one, forward)
      moves << push_two if is_unpushed? && board[push_two].empty?
    end
    # add the attacking moves
    attack_dirs.each do |attack_dir|
      attack = add_direction(pos, attack_dir)
      moves << attack if board.in_bounds?(attack) &&
        !board[attack].empty? &&
        board[attack].color != color
    end
    moves
  end

  protected

  def symbol
    "P"
  end

  private

  def is_unpushed?
    (pos[0] == 1 && color == :white) || (pos[0] == 6 && color == :black)
  end

  def forward_dir
    color == :white ? -1 : 1
  end

  def forward
    [forward_dir, 0]
  end

  def attack_dirs
    [[forward_dir, 1],
     [forward_dir, -1]]
  end
end
