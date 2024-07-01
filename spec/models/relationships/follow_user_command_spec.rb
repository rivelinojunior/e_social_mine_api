# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationships::FollowUserCommand do
  describe '.call' do
    subject(:follow_user) { described_class.call(follower_id:, followee_id:) }

    let(:follower) { create(:user) }
    let(:followee) { create(:user) }

    context 'with valid parameters' do
      let(:follower_id) { follower.id }
      let(:followee_id) { followee.id }

      it 'creates a new Relationship' do
        expect { follow_user }.to change(Relationship, :count).by(1)
      end

      it 'returns a status of :created' do
        follow_user => {type:}

        expect(type).to eq(:created)
      end
    end

    context 'with invalid followee_id' do
      let(:follower_id) { follower.id }
      let(:followee_id) { 1_000 }

      it 'does not create a new Relationship' do
        expect { follow_user }.not_to change(Relationship, :count)
      end

      it 'returns a status of :invalid_record' do
        follow_user => {type:}

        expect(type).to eq(:invalid_record)
      end

      it 'includes error messages in the response' do
        follow_user => {errors:}

        expect(errors).to include('Followee must exist')
      end
    end

    context 'with invalid follower_id' do
      let(:follower_id) { 1_000 }
      let(:followee_id) { followee.id }

      it 'does not create a new Relationship' do
        expect { follow_user }.not_to change(Relationship, :count)
      end

      it 'returns a status of :invalid_record' do
        follow_user => {type:}

        expect(type).to eq(:invalid_record)
      end

      it 'includes error messages in the response' do
        follow_user => {errors:}

        expect(errors).to include('Follower must exist')
      end
    end

    context 'when the follower is already following the followee' do
      let(:follower_id) { follower.id }
      let(:followee_id) { followee.id }

      before { create(:relationship, follower:, followee:) }

      it 'does not create a new Relationship' do
        expect { follow_user }.not_to change(Relationship, :count)
      end

      it 'returns a status of :invalid_record' do
        follow_user => {type:}

        expect(type).to eq(:invalid_record)
      end

      it 'includes error messages in the response' do
        follow_user => {errors:}

        expect(errors).to include('Follower has already been taken')
      end
    end
  end
end
