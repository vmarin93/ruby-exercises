# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/ui'

RSpec.describe Game do
  let(:output) { StringIO.new }
  let(:ui) { UI.new(input: input, output: output) }
  let(:board) { Board.new }

  describe '#play' do
    context 'when setting up players' do
      subject(:game) { described_class.new(user_interface: ui, board: board) }

      before do
        allow(board).to receive(:full?).and_return(true)
      end

      context 'when Player 1 chooses Move::X' do
        let(:input) { StringIO.new("Bob\nX\nAlice\n") }

        it 'assigns Move::X to Player 1 and Move::O to Player 2' do
          game.play

          expect(game.player1).to have_attributes(name: 'Bob', move: Move::X)
          expect(game.player2).to have_attributes(name: 'Alice', move: Move::O)
        end

        it 'displays the player assignment summary' do
          game.play

          expect(output.string).to include('Bob plays for X')
          expect(output.string).to include('Alice plays for O')
        end
      end

      context 'when Player 1 chooses Move::O' do
        let(:input) { StringIO.new("Bob\nO\nAlice\n") }

        it 'assigns Move::O to Player 1 and Move::X to Player 2' do
          game.play

          expect(game.player1).to have_attributes(name: 'Bob', move: Move::O)
          expect(game.player2).to have_attributes(name: 'Alice', move: Move::X)
        end
      end
    end

    context 'when playing turns with pre-configured players' do
      let(:player1) { Player.new(name: 'Bob', move: Move::X) }
      let(:player2) { Player.new(name: 'Alice', move: Move::O) }

      subject(:game) do
        described_class.new(
          user_interface: ui,
          board: board,
          player1: player1,
          player2: player2
        )
      end

      context 'when Player 1 wins' do
        let(:input) { StringIO.new("3\n") }

        before do
          [1, 2].each { |pos| board.add_move(Move::X, pos) }
          [4, 5].each { |pos| board.add_move(Move::O, pos) }
        end

        it 'records the winning player, prints the victory message, and stops the loop' do
          game.play

          expect(game.winner).to eq(player1)
          expect(output.string).to include('Game Over! Bob won!')
          expect(output.string).not_to include("Alice's move")
        end
      end

      context 'when Player 2 wins' do
        let(:input) { StringIO.new("9\n6\n") }

        before do
          [1, 2].each { |pos| board.add_move(Move::X, pos) }
          [4, 5].each { |pos| board.add_move(Move::O, pos) }
        end

        it 'records Player 2 as winner and does not prompt Player 1 again' do
          game.play

          expect(game.winner).to eq(player2)
          expect(output.string).to include('Game Over! Alice won!')
          expect(input).to be_eof
        end
      end

      context 'when a player wins on the final (9th) square' do
        let(:input) { StringIO.new("9\n") }

        before do
          [1, 5, 6, 7].each { |pos| board.add_move(Move::X, pos) }
          [2, 3, 4, 8].each { |pos| board.add_move(Move::O, pos) }
        end

        it 'declares the winner instead of a tie' do
          game.play

          expect(board.full?).to be(true)
          expect(game.winner).to eq(player1)
          expect(output.string).to include('Game Over! Bob won!')
          expect(output.string).not_to include("It's a tie!")
        end
      end

      context 'when the board becomes full without a strike' do
        let(:input) { StringIO.new("9\n") }

        before do
          [1, 3, 4, 8].each { |pos| board.add_move(Move::X, pos) }
          [2, 5, 6, 7].each { |pos| board.add_move(Move::O, pos) }
        end

        it 'leaves winner as nil and announces a tie' do
          game.play

          expect(game.winner).to be_nil
          expect(output.string).to include("Game Over! It's a tie!")
          expect(output.string).not_to include('won!')
        end
      end

      context 'when a player enters occupied, out-of-range, or non-numeric positions' do
        let(:input) { StringIO.new("4\n99\nabc\n3\n") }

        before do
          [1, 2].each { |pos| board.add_move(Move::X, pos) }
          [4, 5].each { |pos| board.add_move(Move::O, pos) }
        end

        it 're-prompts until a valid position is chosen without overwriting occupied cells' do
          game.play

          expect(output.string.scan('Invalid move!').size).to eq(3)
          expect(board.grid[1][0]).to eq(Move::O)
          expect(board.grid[0][2]).to eq(Move::X)
          expect(game.winner).to eq(player1)
        end
      end
    end

    context 'when playing a complete game from start to finish' do
      let(:input) { StringIO.new("bob\nx\nalice\n1\n4\n2\n5\n3\n") }
      let(:expected_ending) do
        <<~OUTPUT
           X | X | X
          ---+---+---
           O | O | 6
          ---+---+---
           7 | 8 | 9
          Game Over! Bob won!
        OUTPUT
      end
      subject(:game) { described_class.new(user_interface: ui) }

      it 'runs setup, alternates turns, displays the final board, and announces the winner' do
        game.play

        expect(game.player1).to have_attributes(name: 'Bob', move: Move::X)
        expect(game.player2).to have_attributes(name: 'Alice', move: Move::O)
        expect(game.winner).to eq(game.player1)
        expect(output.string).to include(expected_ending)
      end
    end
  end
end
