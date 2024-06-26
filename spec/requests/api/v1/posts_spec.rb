# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts API V1' do
  describe 'POST /api/v1/posts' do
    subject(:perform_request) { post '/api/v1/posts', params:, as: :json, headers: }

    context 'when the user is authenticated' do
      let(:current_session) { create(:session) }

      let(:headers) do
        {
          'Authorization' => "Bearer #{current_session.token}"
        }
      end

      context 'with valid params' do
        let(:params) do
          {
            content: 'Hello, world! #practiceMakesPerfect'
          }
        end

        it 'returns a 201 status code' do
          perform_request

          expect(response).to have_http_status(:created)
        end

        it 'returns the created post' do
          perform_request

          post = Post.last

          expect(response.parsed_body).to eq(
            'id' => post.id,
            'content' => 'Hello, world! #practiceMakesPerfect',
            'user_id' => current_session.user_id,
            'created_at' => post.created_at.iso8601(3),
            'hashtags' => ['practiceMakesPerfect']
          )
        end
      end

      context 'with invalid content' do
        let(:params) do
          {
            content: ''
          }
        end

        it 'returns a 422 status code' do
          perform_request

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          perform_request

          expect(response.parsed_body).to eq(
            'errors' => ["Content can't be blank"]
          )
        end
      end
    end

    context 'when the user is not authenticated' do
      let(:headers) { {} }
      let(:params) { {} }

      it 'returns a 401 status code' do
        perform_request

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
