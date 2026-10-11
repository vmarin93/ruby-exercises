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

  sig { params(user_interface: UI).void }
  def initialize(user_interface: UI.new)
    @ui = T.let(user_interface, UI)
    @board = T.let(Board.new, Board)
    @player1 = T.let(nil, T.nilable(Player))
    @player2 = T.let(nil, T.nilable(Player))
  end

  sig { void }
  def play
    set_players
  end

  private

  sig { void }
  def set_players
    @player1 = Player.new(name: ui.prompt_for_player_name('Player1 name: '),
                          move: ui.prompt_for_move('Choose a move for Player1: '))
    @player2 = Player.new(name: ui.prompt_for_player_name('Player2 name: '),
                          move: @player1.move.opposite)
    ui.output.puts "Player #{@player2.name} was assigned move #{@player2.move.serialize}"
  end
end
