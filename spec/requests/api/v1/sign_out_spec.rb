# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::SignOutController' do
  describe 'DELETE /api/v1/sign_out' do
    subject(:perform_request) { delete '/api/v1/sign_out', headers: }

    let!(:current_session) { create(:session) }

    context 'when session token is valid' do
      let(:headers) do
        {
          'Authorization' => "Bearer #{current_session.token}"
        }
      end

      it 'returns a 200 status code' do
        perform_request

        expect(response).to have_http_status(:ok)
      end

      it 'destroys the session' do
        expect { perform_request }.to change(Session, :count).by(-1)
      end

      it 'returns an empty response' do
        perform_request

        expect(response.body).to be_empty
      end
    end

    context 'when session token is invalid' do
      let(:headers) do
        {
          'Authorization' => 'Bearer invalid_token'
        }
      end

      it 'returns a 401 status code' do
        perform_request

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
