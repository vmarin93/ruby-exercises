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
end
