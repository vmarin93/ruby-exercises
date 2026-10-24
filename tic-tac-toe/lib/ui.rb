# typed: strict
# frozen_string_literal: true

require 'stringio'
require_relative 'board'
require_relative 'player'
require_relative 'move'

# Defines the UI interface, has methods to interact with the user via STDIN and STDOUT
class UI
  extend T::Sig

  sig { returns T.any(IO, StringIO) }
  attr_reader :input

  sig { returns T.any(IO, StringIO) }
  attr_reader :output

  sig { params(input: T.any(IO, StringIO), output: T.any(IO, StringIO)).void }
  def initialize(input: $stdin, output: $stdout)
    @input = input
    @output = output
  end

  sig { params(prompt: String).returns(String) }
  def prompt_for_player_name(prompt)
    loop do
      output.puts prompt
      name = T.must(input.gets).chomp.capitalize
      return name if valid_name?(name)

      output.puts 'Name must be at least 2 characters. Please try again'
    end
  end

  sig { params(prompt: String).returns(Move) }
  def prompt_for_move(prompt)
    loop do
      output.puts prompt
      move = Move.try_deserialize(T.must(input.gets).chomp.strip.upcase)
      return move if move

      output.puts 'The only valid moves are either "X" or "O". Please choose a valid move!'
    end
  end

  sig { params(board: Board).void }
  def display_board(board)
    cells = board.grid.flatten.map.with_index(1) do |cell, position|
      " #{cell ? cell.serialize : position} "
    end
    rows = cells.each_slice(3).map { |row| row.join('|').rstrip }
    output.puts rows.join("\n---+---+---\n")
  end

  sig { params(player1: Player, player2: Player).void }
  def display_players(player1, player2)
    lines = [player1, player2].map { |player| "#{player.name} plays for #{player.move.serialize}" }
    width = lines.map(&:length).max || 0
    border = "+-#{'-' * width}-+"
    body = lines.map { |line| "| #{line.ljust(width)} |" }
    output.puts [border, *body, border]
  end

  private

  sig { params(name: String).returns(T::Boolean) }
  def valid_name?(name)
    name.length > 1
  end
end
