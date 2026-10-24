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

  describe '#display_board' do
    let(:input) { StringIO.new }
    let(:board) { Board.new }

    context 'when the board has no moves' do
      let(:expected_board) do
        <<~BOARD
           1 | 2 | 3
          ---+---+---
           4 | 5 | 6
          ---+---+---
           7 | 8 | 9
        BOARD
      end

      it 'displays a board with the positions of each cell' do
        ui.display_board(board)

        expect(output.string).to eq(expected_board)
      end
    end

    context 'when the board has moves' do
      let(:expected_board) do
        <<~BOARD
           1 | 2 | 3
          ---+---+---
           X | 5 | 6
          ---+---+---
           7 | 8 | O
        BOARD
      end

      it 'displays a board that shows moves serialized in their respective cells' do
        board.add_move(Move::X, 4)
        board.add_move(Move::O, 9)
        ui.display_board(board)

        expect(output.string).to eq(expected_board)
      end
    end
  end

  describe '#display_players' do
    let(:input) { StringIO.new }

    context 'when the player names have same length' do
      let(:player1) { Player.new(name: 'Player1', move: Move::X) }
      let(:player2) { Player.new(name: 'Player2', move: Move::O) }
      let(:expected_table) do
        <<~TABLE
          +---------------------+
          | Player1 plays for X |
          | Player2 plays for O |
          +---------------------+
        TABLE
      end

      it 'displays the expected table with correct padding and margins' do
        ui.display_players(player1, player2)

        expect(output.string).to eq(expected_table)
      end
    end

    context 'when the player names have different lengths' do
      let(:player1) { Player.new(name: 'Player12345', move: Move::X) }
      let(:player2) { Player.new(name: 'Player2', move: Move::O) }
      let(:expected_table) do
        <<~TABLE
          +-------------------------+
          | Player12345 plays for X |
          | Player2 plays for O     |
          +-------------------------+
        TABLE
      end

      it 'displays the expected table with correct padding and margins' do
        ui.display_players(player1, player2)

        expect(output.string).to eq(expected_table)
      end
    end
  end
end
