# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/ui'
require_relative '../lib/move'

RSpec.describe UI do
  let(:output) { StringIO.new }
  subject(:ui) { described_class.new(input: input, output: output) }

  describe '#prompt_for_player_name' do
    context 'when given a valid name' do
      let(:input) { StringIO.new("bob\n") }

      it 'returns the capitalized name' do
        expect(ui.prompt_for_player_name('Player1 name: ')).to eq('Bob')
      end

      it 'prints the prompt message' do
        ui.prompt_for_player_name('Player1 name: ')

        expect(output.string).to include('Player1 name: ')
      end
    end

    context 'when given an invalid name followed by a valid name' do
      # Simulates typing "a" (invalid, too short), then "Alice" (valid)
      let(:input) { StringIO.new("a\nAlice\n") }

      it 're-prompts and prints the error message' do
        result = ui.prompt_for_player_name('Enter name: ')

        expect(result).to eq('Alice')
        expect(output.string).to include('Name must be at least 2 characters')
      end
    end
  end

  describe '#prompt_for_move' do
    context 'when given a valid x move' do
      let(:input) { StringIO.new("X\n") }

      it 'returns the correct move object' do
        expect(ui.prompt_for_move('Player1 move: ')).to eq(Move::X)
      end
    end

    context 'when given a valid o move' do
      let(:input) { StringIO.new("O\n") }

      it 'returns the correct move object' do
        expect(ui.prompt_for_move('Player1 move: ')).to eq(Move::O)
      end
    end

    context 'when given an invalid move followed by a valid move' do
      let(:input) { StringIO.new("z\nx\n") }

      it 're-prompts and prints the error message' do
        result = ui.prompt_for_move('Player1 move: ')

        expect(result).to eq(Move::X)
        expect(output.string).to include('Please choose a valid move!')
      end
    end
  end
end
