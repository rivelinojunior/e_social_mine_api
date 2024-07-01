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

  describe 'associations' do
    subject(:user) { build(:user) }

    it { is_expected.to have_many(:sessions).dependent(:destroy) }

    it do
      expect(user)
        .to have_many(:following_relationships)
        .class_name('Relationship')
        .with_foreign_key('follower_id')
        .dependent(:destroy)
        .inverse_of(:follower)
    end

    it do
      expect(user)
        .to have_many(:follower_relationships)
        .class_name('Relationship')
        .with_foreign_key('followee_id')
        .dependent(:destroy)
        .inverse_of(:followee)
    end

    it { is_expected.to have_many(:followees).through(:following_relationships) }
    it { is_expected.to have_many(:followers).through(:follower_relationships) }
  end
end
