# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/game'
require_relative '../lib/ui'

RSpec.describe Game do
  let(:output) { StringIO.new }
  subject(:game) { described_class.new(user_interface: UI.new(input: input, output: output)) }

  describe '#play' do
    context 'Player2 gets Move::O when Player1 gets Move::X' do
      let(:input) { StringIO.new("Bob\nX\nAlice\n") }

      it 'assigns the correct moves to the correct players' do
        game.play

        expect(game.player1.move).to eq(Move::X)
        expect(game.player2.move).to eq(Move::O)
      end
    end

    context 'Player2 gets Move::X when Player1 gets Move::O' do
      let(:input) { StringIO.new("Bob\nO\nAlice\n") }

      it 'assigns the correct moves to the correct players' do
        game.play

        expect(game.player1.move).to eq(Move::O)
        expect(game.player2.move).to eq(Move::X)
      end
    end
  end
end
