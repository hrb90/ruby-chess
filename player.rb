require_relative 'display'

class Player
  attr_accessor :color
  attr_reader :name, :board

  def initialize(name = nil, color = nil)
    name ||= "Outis"
    @name = name
    @color = color
  end

  def add_board(board)
    @board = board
  end

  def alert_error(msg)
    puts msg
  end

  def alert_game_over
  end
end

class HumanPlayer < Player
  def get_move
    display.get_move
  end

  def add_board(board)
    super
    @display = Display.new(board)
  end

  def alert_game_over
    display.render
    puts "Game over!"
  end

  private

  attr_reader :display
end
