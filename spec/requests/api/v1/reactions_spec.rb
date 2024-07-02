# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reactions API V1' do
  describe 'POST /api/v1/posts/{{post_id}}/reactions' do
    subject(:perform_request) { post "/api/v1/posts/#{post_id}/reactions", params:, as: :json, headers: }

    context 'when the user is authenticated' do
      let(:current_session) { create(:session) }

      let(:headers) do
        {
          'Authorization' => "Bearer #{current_session.token}"
        }
      end

      context 'with valid post_id and kind' do
        let(:post_id) { create(:post).id }

        let(:params) do
          {
            kind: 'like'
          }
        end

        it 'returns a 201 status code' do
          perform_request

          expect(response).to have_http_status(:created)
        end

        it 'returns the created reaction' do
          perform_request

          reaction = Reaction.last

          expect(response.parsed_body).to eq(
            'id' => reaction.id,
            'kind' => 'like',
            'user_id' => current_session.user.id,
            'post_id' => post_id,
            'created_at' => reaction.created_at.iso8601(3),
            'user' => {
              'email' => current_session.user.email,
              'username' => current_session.user.username,
              'full_name' => current_session.user.full_name
            }
          )
        end
      end

      context 'with invalid kind' do
        let(:post_id) { create(:post).id }

        let(:params) do
          {
            kind: 'invalid'
          }
        end

        it 'returns a 422 status code' do
          perform_request

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the errors' do
          perform_request

          expect(response.parsed_body).to eq(
            'errors' => ["'invalid' is not a valid kind"]
          )
        end
      end

      context 'with invalid post_id' do
        let(:post_id) { 0 }

        let(:params) do
          {
            kind: 'like'
          }
        end

        it 'returns a 422 status code' do
          perform_request

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the errors' do
          perform_request

          expect(response.parsed_body).to eq(
            'errors' => ['Post must exist']
          )
        end
      end
    end

    context 'when the user is not authenticated' do
      let(:headers) { {} }
      let(:post_id) { 0 }
      let(:params) { {} }

      it 'returns a 401 status code' do
        perform_request

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
