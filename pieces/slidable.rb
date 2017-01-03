require_relative 'movable'

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
