# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Session do
  describe '#validations' do
    subject(:session) { build(:session) }

    it { is_expected.to validate_presence_of(:token) }
    it { is_expected.to validate_uniqueness_of(:token) }
    it { is_expected.to validate_presence_of(:refresh_token) }
    it { is_expected.to validate_uniqueness_of(:refresh_token) }
    it { is_expected.to validate_presence_of(:expires_in) }
    it { is_expected.to validate_presence_of(:refresh_expires_in) }
  end

  describe '#associations' do
    it { is_expected.to belong_to(:user) }
  end
end
