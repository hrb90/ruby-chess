require_relative 'movable'
require_relative 'piece'

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
    color == :white ? "♙" : "♟"
  end

  private

  def is_unpushed?
    (pos[0] == 1 && color == :black) || (pos[0] == 6 && color == :white)
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
