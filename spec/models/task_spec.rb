# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'generates valid factory' do
    expect(FactoryBot.build(:task)).to be_valid
  end

  describe '#title' do
    context 'blank' do
      subject(:task) { FactoryBot.build(:task, title: '') }

      it 'validation fails' do
        expect(task).to_not be_valid
      end
    end
  end
end
