# typed: strict
# frozen_string_literal: true

require 'stringio'

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
      move = Move.try_deserialize(T.must(input.gets).chomp.strip.downcase)
      return move if move

      output.puts 'The only valid moves are either "x" or "o". Please choose a valid move!'
    end
  end

  private

  sig { params(name: String).returns(T::Boolean) }
  def valid_name?(name)
    name.length > 1
  end
end
