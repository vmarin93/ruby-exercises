# typed: strict
# frozen_string_literal: true

require_relative 'move'

# Defines the Player. A Player has a name and a move
class Player < T::Struct
  const :name, String
  const :move, Move
end
