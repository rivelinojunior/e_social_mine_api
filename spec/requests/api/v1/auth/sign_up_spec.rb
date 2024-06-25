# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Auth::SignUpController' do
  describe 'POST /api/v1/auth/sign_up' do
    subject(:perform_request) { post '/api/v1/auth/sign_up', params:, as: :json }

    before { freeze_time }

    context 'with valid parameters' do
      let(:params) do
        {
          user: {
            full_name: 'Rivelino Junior',
            username: 'rivelinojunior',
            email: 'rivelino.junior@gmail.com',
            password: '9gU1qbBSoT',
            password_confirmation: '9gU1qbBSoT'
          }
        }
      end

      it 'creates a new User' do
        expect { perform_request }.to change(User, :count).by(1)
      end

      it 'returns a 201 status code' do
        perform_request

        expect(response).to have_http_status(:created)
      end

      it 'returns created user' do
        perform_request

        expect(response.parsed_body).to eq(
          'id' => User.last.id,
          'full_name' => 'Rivelino Junior',
          'username' => 'rivelinojunior',
          'email' => 'rivelino.junior@gmail.com',
          'created_at' => Time.current.iso8601(3),
          'updated_at' => Time.current.iso8601(3)
        )
      end
    end

    context 'with invalid parameters' do
      let(:params) do
        {
          user: {
            full_name: '',
            username: '',
            email: '',
            password: '9gU1qbBSoT',
            password_confirmation: 'different'
          }
        }
      end

      it 'does not create a new User' do
        expect { perform_request }.not_to change(User, :count)
      end

      it 'returns a 422 status code' do
        perform_request

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'retruns error messages' do
        perform_request

        expect(response.parsed_body).to eq(
          'errors' => [
            "Password confirmation doesn't match Password",
            "Full name can't be blank",
            "Username can't be blank",
            "Email can't be blank",
            'Email is not an email'
          ]
        )
      end
    end
  end
end
