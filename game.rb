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
    players.each do |color, player|
      player.color = color
      player.add_board(board)
    end
  end

  def play
    until board.over?
      take_turn
      switch_players!
    end
    players.each do |_, player|
      player.alert_game_over
    end
  end

  private

  attr_reader :board, :players, :curr_player

  def take_turn
    player = players[curr_player]
    begin
      move = player.get_move
      if [:kingside, :queenside].include?(move)
        board.castle(move, curr_player)
      else
        start_pos, end_pos = move
        unless board[start_pos].color == curr_player
          raise WrongColorException.new("Oops, wrong color!")
        end
        board.move_piece(start_pos, end_pos)
      end
    rescue ChessException => e
      player.alert_error(e.message)
      retry
    end
  end

  def switch_players!
    @curr_player = curr_player == :white ? :black : :white
  end
end
