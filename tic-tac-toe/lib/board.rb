# typed: strict
# frozen_string_literal: true

# Defines the nested array that will hold all the positions on the board as strings
class Board
  extend T::Sig

  sig { returns T::Array[T::Array[T.nilable(String)]] }
  attr_reader :board

  sig { void }
  def initialize
    @board = T.let(Array.new(3) { Array.new(3) }, T::Array[T::Array[T.nilable(String)]])
  end

  private

  sig { returns(T::Array[T::Array[T.nilable(String)]]) }
  def clear!
    board.each do |row|
      row.map { nil }
    end
  end

  sig { returns(NilClass) }
  def full?
    # pass
  end

  sig { returns(NilClass) }
  def strike?
    # pass
  end

  sig { returns(NilClass) }
  def add_move
    # pass
  end
end
