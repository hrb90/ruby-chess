require_relative 'game'
require_relative 'player'

p1 = HumanPlayer.new("Greco")
p2 = HumanPlayer.new
Game.new(p1, p2).play
