# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Auth::SignInController' do
  describe 'POST /api/v1/auth/sign_in' do
    subject(:perform_request) { post '/api/v1/auth/sign_in', params:, as: :json }

    let!(:user) do
      create(:user, email: 'rivelino@gmail.com', password: '9gU1qbBSoT', password_confirmation: '9gU1qbBSoT')
    end

    context 'with valid credentials' do
      let(:params) do
        {
          email: 'rivelino@gmail.com',
          password: '9gU1qbBSoT'
        }
      end

      it 'returns a 200 status code' do
        perform_request

        expect(response).to have_http_status(:ok)
      end

      it 'returns a session' do
        perform_request

        user.reload
        session = user.sessions.last

        expect(response.parsed_body).to eq(
          'user_id' => user.id,
          'token' => session.token,
          'refresh_token' => session.refresh_token,
          'expires_in' => session.expires_in.iso8601(3),
          'refresh_expires_in' => session.refresh_expires_in.iso8601(3),
          'created_at' => session.created_at.iso8601(3),
          'email' => user.email
        )
      end
    end

    context 'with invalid email' do
      let(:params) do
        {
          email: 'r@gmail.com',
          password: '9gU1qbBSoT'
        }
      end

      it 'returns a 401 status code' do
        perform_request

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        perform_request

        expect(response.parsed_body).to eq('errors' => ['invalid credentials'])
      end
    end

    context 'with invalid password' do
      let(:params) do
        {
          email: 'rivelino@gmail.com',
          password: '9gU1qbBSoT------'
        }
      end

      it 'returns a 401 status code' do
        perform_request

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        perform_request

        expect(response.parsed_body).to eq('errors' => ['invalid credentials'])
      end
    end
  end
end
