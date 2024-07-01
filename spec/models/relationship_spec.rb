# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship do
  describe 'validations' do
    subject(:relationship) { build(:relationship) }

    it { is_expected.to validate_uniqueness_of(:follower_id).scoped_to(:followee_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:follower).class_name('User') }
    it { is_expected.to belong_to(:followee).class_name('User') }
  end
end
