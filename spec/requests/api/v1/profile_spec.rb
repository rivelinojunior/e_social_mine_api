# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Profile API' do
  describe 'PUT /api/v1/profile' do
    subject(:perform_request) { put '/api/v1/profile', params:, as: :json, headers: }

    context 'when the user is authenticated' do
      let!(:current_user) { create(:user, full_name: 'Jane Doe', username: 'jane_doe') }
      let(:current_session) { create(:session, user: current_user) }

      let(:headers) do
        {
          'Authorization' => "Bearer #{current_session.token}"
        }
      end

      context 'with valid full_name and username' do
        let(:params) do
          {
            full_name: 'John Doe',
            username: 'john_doe'
          }
        end

        it 'returns a 200 status code' do
          perform_request

          expect(response).to have_http_status(:ok)
        end

        it 'returns the updated user' do
          perform_request

          current_user.reload

          expect(response.parsed_body).to eq(
            'id' => current_user.id,
            'email' => current_user.email,
            'username' => 'john_doe',
            'full_name' => 'John Doe',
            'updated_at' => current_user.updated_at.iso8601(3),
            'created_at' => current_user.created_at.iso8601(3)
          )
        end
      end

      context 'with invalid full_name' do
        let(:params) do
          {
            full_name: '',
            username: 'john_doe'
          }
        end

        it 'returns a 422 status code' do
          perform_request

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          perform_request

          expect(response.parsed_body).to eq(
            'errors' => ["Full name can't be blank"]
          )
        end
      end

      context 'with invalid username' do
        let(:params) do
          {
            full_name: 'John Doe',
            username: ''
          }
        end

        it 'returns a 422 status code' do
          perform_request

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          perform_request

          expect(response.parsed_body).to eq(
            'errors' => ["Username can't be blank"]
          )
        end
      end
    end

    context 'when the user is not authenticated' do
      let(:params) do
        {}
      end

      it 'returns a 401 status code' do
        perform_request

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
