# typed: strict
# frozen_string_literal: true

# Defines all possible moves in the game as an enum. A move can either be X or O
class Move < T::Enum
  enums do
    X = new('x')
    O = new('o')
  end
end
