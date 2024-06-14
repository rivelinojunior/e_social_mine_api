# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::SignOutCommand do
  describe '#call' do
    subject(:sign_out) { described_class.call(params:) }

    let!(:session) { create(:session) }

    context 'when session token is valid' do
      let(:params) do
        {
          token: session.token
        }
      end

      it do
        expect { sign_out }.to change(Session, :count).by(-1)
      end

      it 'deletes the session for the given token' do
        sign_out

        expect { session.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'returns a success result' do
        expect(sign_out).to be_a(Result::Success)
      end
    end

    context 'when session token is invalid' do
      let(:params) do
        {
          token: 'invalid_token'
        }
      end

      it do
        expect { sign_out }.to raise_error(ActiveRecord::RecordNotFound, /Couldn't find Session/)
      end
    end
  end
end
