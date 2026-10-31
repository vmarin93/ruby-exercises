# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require_relative 'board'
require_relative 'move'
require_relative 'player'
require_relative 'ui'

# Defines the Game state and game loop
class Game
  extend T::Sig

  sig { returns UI }
  attr_reader :ui

  sig { returns Board }
  attr_reader :board

  sig { returns(T.nilable(Player)) }
  attr_reader :player1

  sig { returns(T.nilable(Player)) }
  attr_reader :player2

  sig { returns(T.nilable(Player)) }
  attr_reader :winner

  sig do
    params(
      user_interface: UI,
      board: Board,
      player1: T.nilable(Player),
      player2: T.nilable(Player)
    ).void
  end
  def initialize(user_interface: UI.new, board: Board.new, player1: nil, player2: nil)
    @ui = T.let(user_interface, UI)
    @board = T.let(board, Board)
    @player1 = T.let(player1, T.nilable(Player))
    @player2 = T.let(player2, T.nilable(Player))
    @winner = T.let(nil, T.nilable(Player))
  end

  sig { void }
  def play
    set_players
    p1 = T.must(@player1)
    p2 = T.must(@player2)
    ui.display_players(p1, p2)
    play_turns(p1, p2)
    finish_game
  end

  private

  sig { params(player1: Player, player2: Player).void }
  def play_turns(player1, player2)
    [player1, player2].cycle do |current_player|
      break if game_over?

      turn(current_player)
    end
  end

  sig { params(player: Player).void }
  def turn(player)
    ui.display_board(@board)
    loop do
      position = ui.prompt_for_position("#{player.name}'s move")
      break if @board.add_move(player.move, position)

      ui.display_message('Invalid move! Please choose an unoccupied position between 1 and 9.')
    end
    @winner = player if @board.strike?
  end

  sig { void }
  def set_players
    return if @player1 && @player2

    p1 = Player.new(name: ui.prompt_for_player_name('Player1 name: '),
                    move: ui.prompt_for_move('Choose a move for Player1: '))
    @player1 = p1
    @player2 = Player.new(name: ui.prompt_for_player_name('Player2 name: '),
                          move: p1.move.opposite)
  end

  sig { returns(T::Boolean) }
  def game_over?
    @board.strike? || @board.full?
  end

  sig { void }
  def finish_game
    ui.display_board(@board)
    if @winner
      ui.display_message("Game Over! #{@winner.name} won!")
    else
      ui.display_message("Game Over! It's a tie!")
    end
  end
end
