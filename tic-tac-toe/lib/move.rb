# typed: strict
# frozen_string_literal: true

# Defines all possible moves in the game as an enum. A move can either be X or O
class Move < T::Enum
  enums do
    X = new('X')
    O = new('O')
  end

  sig { returns Move }
  def opposite
    self == X ? O : X
  end
end
