# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reaction do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:kind) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post) }
  end

  describe '.kinds' do
    subject(:kinds) { described_class.kinds }

    it do
      expect(kinds).to eq(
        'like' => 'like',
        'celebrate' => 'celebrate',
        'support' => 'support',
        'love' => 'love',
        'insightful' => 'insightful',
        'funny' => 'funny'
      )
    end
  end
end
