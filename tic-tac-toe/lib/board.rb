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

  sig { returns(T::Array[T::Array[T.nilable(Move)]]) }
  def clear!
    board.each { |row| row.fill(nil) }
  end

  sig { returns(T::Boolean) }
  def full?
    board.flatten.none?(&:nil?)
  end

  sig { returns(T::Boolean) }
  def strike?
    winning_lines = board + board.transpose + diagonals

    winning_lines.any? do |line|
      line.none?(&:nil?) && line.uniq.size == 1
    end
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

  sig { returns(T::Array[T::Array[T.nilable(Move)]]) }
  def diagonals
    r0 = T.must(board[0])
    r1 = T.must(board[1])
    r2 = T.must(board[2])

    [
      [r0[0], r1[1], r2[2]],
      [r0[2], r1[1], r2[0]]
    ]
  end
end
