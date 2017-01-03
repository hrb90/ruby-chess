require_relative 'board'
require_relative 'chess_exception'
require_relative 'player'

class WrongColorException < ChessException
end

class Game
  def initialize(white_player, black_player)
    @board = Board.new
    @players = {
      white: white_player,
      black: black_player
    }
    @curr_player = :white
    white_player.color = :white
    white_player.add_board(board)
    black_player.color = :black
    black_player.add_board(board)
  end

  def play
    until board.over?
      take_turn
      switch_players!
    end
  end

  private

  attr_reader :board, :players, :curr_player

  def take_turn
    player = players[curr_player]
    begin
      start_pos, end_pos = player.get_move
      unless board[start_pos].color == curr_player
        raise WrongColorException.new("Oops, wrong color!")
      end
      board.move_piece(start_pos, end_pos)
    rescue ChessException => e
      player.alert_error(e.message)
      retry
    end
  end

  def switch_players!
    @curr_player = curr_player == :white ? :black : :white
  end
end
