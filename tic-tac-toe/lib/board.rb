# typed: strict
# frozen_string_literal: true

require_relative 'move'

# Defines the nested array that will hold all the positions on the board as strings
class Board
  extend T::Sig

  sig { returns T::Array[T::Array[T.nilable(Move)]] }
  attr_reader :board

  sig { void }
  def initialize
    @board = T.let(Array.new(3) { Array.new(3) }, T::Array[T::Array[T.nilable(Move)]])
  end

  sig { returns(NilClass) }
  def clear!
    # pass
  end

  sig { returns(T::Boolean) }
  def full?
    board.flatten.none?(&:nil?)
  end

  sig { returns(NilClass) }
  def strike?
    # pass
  end

  sig do
    params(move: Move, index: Integer).returns(T::Boolean)
  end
  def add_move(move, index)
    return false unless valid_move?(index)

    row = (index - 1) / 3
    col = (index - 1) % 3

    T.must(board[row])[col] = move
    true
  end

  private

  sig do
    params(index: Integer).returns(T::Boolean)
  end
  def valid_move?(index)
    return false unless index.between?(1, 9)

    row = (index - 1) / 3
    col = (index - 1) % 3

    T.must(board[row])[col].nil?
  end
end
