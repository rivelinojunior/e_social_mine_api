# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationships::UnfollowUserCommand do
  describe '.call' do
    subject(:follow_user) { described_class.call(follower_id:, followee_id:) }

    let(:follower) { create(:user) }
    let(:followee) { create(:user) }

    before { create(:relationship, follower:, followee:) }

    context 'with valid parameters' do
      let(:follower_id) { follower.id }
      let(:followee_id) { followee.id }

      it 'destroys the relationship between the given users' do
        expect { follow_user }.to change(Relationship, :count).by(-1)
      end

      it 'returns a status of :ok' do
        follow_user => {type:}

        expect(type).to eq(:ok)
      end
    end

    context 'with invalid followee_id' do
      let(:follower_id) { follower.id }
      let(:followee_id) { 1_000 }

      it 'does not destroy any relationship' do
        expect { follow_user }.not_to change(Relationship, :count)
      end

      it 'returns a status of :not_found' do
        follow_user => {type:}

        expect(type).to eq(:not_found)
      end

      it 'includes error messages in the response' do
        follow_user => {errors:}

        expect(errors).to include(/Couldn't find Relationship with/)
      end
    end

    context 'with invalid follower_id' do
      let(:follower_id) { 1_000 }
      let(:followee_id) { followee.id }

      it 'does not destroy any relationship' do
        expect { follow_user }.not_to change(Relationship, :count)
      end

      it 'returns a status of :not_found' do
        follow_user => {type:}

        expect(type).to eq(:not_found)
      end

      it 'includes error messages in the response' do
        follow_user => {errors:}

        expect(errors).to include(/Couldn't find Relationship with/)
      end
    end
  end
end
