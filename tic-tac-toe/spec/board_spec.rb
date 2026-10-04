# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/board'

RSpec.describe Board do
  let(:fresh_board) do
    [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  describe '#initialize' do
    subject(:board) { described_class.new }

    it 'creates a 3x3 grid with all cells set to nil' do
      expect(board.board).to eq(fresh_board)
    end
  end

  describe '#add_move' do
    subject(:board) { described_class.new }

    it 'adds a move on the board index is valid' do
      result = board.add_move(Move::X, 1)

      expect(result).to be(true)
      expect(board.board[0][0]).to eq(Move::X)
    end

    it 'does not add a move if index is invalid' do
      result = board.add_move(Move::X, 10)

      expect(result).to be(false)
      expect(board.board).to eq(fresh_board)
    end

    it 'does not add a move if cell is occupied' do
      board.add_move(Move::X, 1)
      result = board.add_move(Move::O, 1)

      expect(result).to be(false)
      expect(board.board[0][0]).to eq(Move::X)
    end
  end

  describe '#full?' do
    subject(:board) { described_class.new }
    it 'returns false when board is empty' do
      expect(board.full?).to be(false)
    end

    it 'returns true when board is full' do
      (1..9).each { |i| board.add_move(Move::X, i) }

      expect(board.full?).to be(true)
    end
  end
end
