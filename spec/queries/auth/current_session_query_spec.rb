# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::CurrentSessionQuery do
  describe '.query' do
    subject(:query) { described_class.query(token:) }

    let(:token) { current_session.token }
    let(:current_session) { create(:session) }

    context 'when session is valid' do
      it 'returns a success result' do
        expect(query).to be_a(Result::Success)
      end

      it 'returns the session and user' do
        result = query

        expect(result.value).to eq(
          session: current_session,
          user: current_session.user
        )
      end
    end

    context 'when session is expired' do
      let(:current_session) { create(:session, :expired) }

      it 'returns a failure result' do
        expect(query).to be_a(Result::Failure)
      end

      it 'returns an expired failure type' do
        query => {type:}

        expect(type).to eq(:expired)
      end

      it 'returns an error message' do
        query => {errors:}

        expect(errors).to eq(['session expired'])
      end
    end

    context 'when session is not found' do
      let(:token) { 'invalid_token' }

      it 'returns a failure result' do
        expect(query).to be_a(Result::Failure)
      end

      it 'returns an not_found failure type' do
        query => {type:}

        expect(type).to eq(:not_found)
      end

      it 'returns an error message' do
        query => {errors:}

        expect(errors).to match([/Couldn't find Session/])
      end
    end
  end
end
