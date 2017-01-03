require_relative 'movable'

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
