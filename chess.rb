require_relative 'board'
require_relative 'display'

board = Board.new
display = Display.new(board)

#Ruy Lopez
# TEST_MOVES = [
#   [[6, 4], [4, 4]], #e4
#   [[1, 4], [3, 4]], #e5
#   [[7, 6], [5, 5]], #Nf3
#   [[0, 1], [2, 2]], #Nc6
#   [[7, 5], [3, 1]], #Bb5
#   [[1, 0], [2, 0]], #a6
#   [[3, 1], [2, 2]], #Bxc6
#   [[1, 3], [2, 2]], #dxc6
#   [[7, 1], [5, 2]], #Nc3
#   [[0, 5], [2, 3]], #Bd6
#   [[6, 3], [4, 3]], #d4
#   [[0, 3], [1, 4]], #Qe7
#   [[4, 3], [3, 4]], #dxe5
#   [[2, 3], [3, 4]], #Bxe5
#   [[5, 5], [3, 4]], #Nxe5
#   [[1, 4], [3, 4]], #Qxe5
#   [[7, 3], [5, 5]], #Qf3
#   [[0, 2], [2, 4]], #Be6
#   [[7, 2], [4, 5]], #Bf4
#   [[3, 4], [3, 0]]  #Qa5
# ]

#Fool's mate
TEST_MOVES = [
  [[6, 5], [5, 5]], #f3
  [[1, 4], [3, 4]], #e5
  [[6, 6], [4, 6]], #g4
  [[0, 3], [4, 7]]  #Qh4#
]

TEST_MOVES.each do |start_pos, end_pos|
  system "clear"
  board.move_piece(start_pos, end_pos)
  display.render
  sleep 2
end
puts board.checkmate?(:white)
