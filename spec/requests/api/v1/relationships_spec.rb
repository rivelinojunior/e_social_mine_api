# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Relationships API V1' do
  describe 'POST /api/v1/relationships' do
    subject(:perform_request) { post '/api/v1/relationships', params:, as: :json, headers: }

    context 'when the user is authenticated' do
      let(:current_session) { create(:session) }

      let(:headers) do
        {
          'Authorization' => "Bearer #{current_session.token}"
        }
      end

      context 'with valid followee' do
        let(:params) do
          {
            followee_id: create(:user).id
          }
        end

        it 'returns a 201 status code' do
          perform_request

          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid followee' do
        let(:params) do
          {
            followee_id: 1_000
          }
        end

        it 'returns a 422 status code' do
          perform_request

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          perform_request

          expect(response.parsed_body).to eq(
            'errors' => ['Followee must exist']
          )
        end
      end

      context 'when the user is already following the followee' do
        let(:followee) { create(:user) }
        let(:params) do
          {
            followee_id: followee.id
          }
        end

        before do
          Relationships::FollowUserCommand.call(follower_id: current_session.user_id, followee_id: followee.id)
        end

        it 'returns a 422 status code' do
          perform_request

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          perform_request

          expect(response.parsed_body).to eq(
            'errors' => ['Follower has already been taken']
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

  describe 'DELETE /api/v1/relationships/:followee_id' do
    subject(:perform_request) { delete "/api/v1/relationships/#{followee_id}", headers: }

    let(:followee_id) { create(:user).id }

    context 'when the user is authenticated' do
      let(:current_session) { create(:session) }

      let(:headers) do
        {
          'Authorization' => "Bearer #{current_session.token}"
        }
      end

      context 'with valid followee' do
        before { create(:relationship, follower_id: current_session.user_id, followee_id:) }

        it 'returns a 200 status code' do
          perform_request

          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid followee' do
        let(:followee_id) { 1_000 }

        it 'returns a 404 status code' do
          perform_request

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when the user is not authenticated' do
      let(:headers) { {} }

      it 'returns a 401 status code' do
        perform_request

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
