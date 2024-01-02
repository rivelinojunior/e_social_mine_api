# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:full_name) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:email) }

    context 'when user email is invalid' do
      subject(:user) { build(:user, email: 'invalid_email.com') }

      it do
        user.valid?

        expect(user.errors.full_messages).to eq(['Email is not an email'])
      end
    end
  end
end
