# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Posts::CreateCommentCommand do
  describe '.call' do
    subject(:create_comment) { described_class.call(message:, user_id:, post_id:) }

    context 'when message, user_id, and post_id are valid' do
      let(:user_id) { create(:user).id }
      let(:post_id) { create(:post).id }
      let(:message) { 'Hello, world!' }

      it 'creates a new Comment' do
        expect { create_comment }.to change(Comment, :count).by(1)
      end

      it 'returns a status of :created' do
        create_comment => Result::Success(type:)

        expect(type).to eq(:created)
      end

      it 'includes comment data in the response' do
        create_comment => Result::Success(value: {comment:})

        expect(comment).to have_attributes(
          id: be_present.and(be_a Integer),
          message: 'Hello, world!',
          user_id:,
          post_id:,
          created_at: be_present.and(be_a Time),
          updated_at: be_present.and(be_a Time)
        )
      end
    end

    context 'when message is empty' do
      let(:user_id) { create(:user).id }
      let(:post_id) { create(:post).id }
      let(:message) { '' }

      it 'does not create a new Comment' do
        expect { create_comment }.not_to change(Comment, :count)
      end

      it 'returns a status of :invalid_record' do
        create_comment => Result::Failure(type:)

        expect(type).to eq(:invalid_record)
      end

      it 'includes an error message in the response' do
        create_comment => Result::Failure(value: {errors:})

        expect(errors).to include("Message can't be blank")
      end
    end

    context 'when user_id is invalid' do
      let(:user_id) { 0 }
      let(:post_id) { create(:post).id }
      let(:message) { 'Hello, world!' }

      it 'does not create a new Comment' do
        expect { create_comment }.not_to change(Comment, :count)
      end

      it 'returns a status of :invalid_record' do
        create_comment => Result::Failure(type:)

        expect(type).to eq(:invalid_record)
      end

      it 'includes an error message in the response' do
        create_comment => Result::Failure(value: {errors:})

        expect(errors).to include('User must exist')
      end
    end

    context 'when post_id is invalid' do
      let(:user_id) { create(:user).id }
      let(:post_id) { 0 }
      let(:message) { 'Hello, world!' }

      it 'does not create a new Comment' do
        expect { create_comment }.not_to change(Comment, :count)
      end

      it 'returns a status of :invalid_record' do
        create_comment => Result::Failure(type:)

        expect(type).to eq(:invalid_record)
      end

      it 'includes an error message in the response' do
        create_comment => Result::Failure(value: {errors:})

        expect(errors).to include('Post must exist')
      end
    end
  end
end
