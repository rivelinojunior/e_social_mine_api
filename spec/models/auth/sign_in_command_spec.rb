# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::SignInCommand do
  describe '#call' do
    subject(:sign_in) { described_class.call(params:) }

    let!(:user_params) { create(:user) }

    before { freeze_time }

    context 'with valid credentials' do
      let(:params) do
        {
          email: user_params.email,
          password: user_params.password
        }
      end

      it 'creates a session' do
        expect { sign_in }.to change(Session, :count).by(1)
      end

      it 'returns a success result' do
        response = sign_in

        expect(response).to be_a(Result::Success)
      end

      it 'returns a session for the right user' do
        sign_in => {session:}

        expect(session).to have_attributes(
          user_id: user_params.id,
          token: be_a(String),
          refresh_token: be_a(String),
          expires_in: be_within(2.hours).of(2.hours.from_now),
          refresh_expires_in: be_within(1.week).of(1.week.from_now),
          refreshed_at: nil
        )
      end

      it 'returns the user' do
        sign_in => {user:}

        expect(user).to eq(user_params)
      end
    end

    context 'with invalid email' do
      let(:params) do
        {
          email: 'invalid@gmail.com',
          password: user_params.password
        }
      end

      it 'returns a failure result' do
        response = sign_in

        expect(response).to be_a(Result::Failure)
      end

      it 'returns an error message' do
        sign_in => {errors:}

        expect(errors).to match([/Couldn't find User/])
      end

      it 'does not create a session' do
        expect { sign_in }.not_to change(Session, :count)
      end

      it 'return not_found failure type' do
        sign_in => {type:}

        expect(type).to eq(:not_found)
      end
    end

    context 'with invalid password' do
      let(:params) do
        {
          email: user_params.email,
          password: 'invalid'
        }
      end

      it 'returns a failure result' do
        response = sign_in

        expect(response).to be_a(Result::Failure)
      end

      it 'returns an error message' do
        sign_in => {errors:}

        expect(errors).to match(['invalid credentials'])
      end

      it 'does not create a session' do
        expect { sign_in }.not_to change(Session, :count)
      end

      it 'return unauthorized failure type' do
        sign_in => {type:}

        expect(type).to eq(:unauthorized)
      end
    end
  end
end
