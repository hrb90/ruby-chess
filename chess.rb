require_relative 'board'
require_relative 'display'

board = Board.new
display = Display.new(board)
display.interact
