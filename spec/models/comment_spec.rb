# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:message) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:user) }
  end
end
