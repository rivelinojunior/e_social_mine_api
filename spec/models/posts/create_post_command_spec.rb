# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Posts::CreatePostCommand do
  describe '.call' do
    subject(:create_post) { described_class.call(content:, user_id:) }

    context 'with valid parameters' do
      let(:content) { 'Hello, world!' }
      let(:user) { create(:user) }
      let(:user_id) { user.id }

      it 'creates a new Post' do
        expect { create_post }.to change(Post, :count).by(1)
      end

      it 'returns a status of :created' do
        create_post => {type:}

        expect(type).to eq(:created)
      end

      it 'includes post data in the response' do
        create_post => {post:}

        expect(post).to have_attributes(
          id: be_present.and(be_a Integer),
          content: 'Hello, world!',
          user_id:,
          created_at: be_present.and(be_a Time),
          updated_at: be_present.and(be_a Time)
        )
      end
    end

    context 'with empty content' do
      let(:content) { '' }
      let(:user) { create(:user) }
      let(:user_id) { user.id }

      it 'does not create a new Post' do
        expect { create_post }.not_to change(Post, :count)
      end

      it 'returns a status of :invalid_record' do
        create_post => {type:}

        expect(type).to eq(:invalid_record)
      end

      it 'includes an error message in the response' do
        create_post => {errors:}

        expect(errors).to include("Content can't be blank")
      end
    end

    context 'with an invalid user_id' do
      let(:content) { 'Hello, world!' }
      let(:user_id) { 0 }

      it 'does not create a new Post' do
        expect { create_post }.not_to change(Post, :count)
      end

      it 'returns a status of :invalid_record' do
        create_post => {type:}

        expect(type).to eq(:invalid_record)
      end

      it 'includes an error message in the response' do
        create_post => {errors:}

        expect(errors).to include('User must exist')
      end
    end

    context 'with a content bigger than 280 characters' do
      let(:content) { 'a' * 281 }
      let(:user) { create(:user) }
      let(:user_id) { user.id }

      it 'does not create a new Post' do
        expect { create_post }.not_to change(Post, :count)
      end

      it 'returns a status of :invalid_record' do
        create_post => {type:}

        expect(type).to eq(:invalid_record)
      end

      it 'includes an error message in the response' do
        create_post => {errors:}

        expect(errors).to include('Content is too long (maximum is 280 characters)')
      end
    end
  end
end
