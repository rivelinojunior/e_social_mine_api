# frozen_string_literal: true

module Auth
  class SignInCommand < ApplicationCommand
    def initialize(params:)
      self.params = params
    end

    def call
      user = User.find_by!(email: params[:email])

      if user.authenticate(params[:password])
        session = create_session(user)
        Result::Success(:ok, session:, user:)
      else
        Result::Failure(:unauthorized, errors: ['invalid credentials'])
      end
    rescue ActiveRecord::RecordNotFound => e
      Result::Failure(:not_found, errors: [e.message])
    end

    private

    attr_accessor :params

    def create_session(user)
      user.sessions.create!(
        token: SecureRandom.alphanumeric(32),
        refresh_token: SecureRandom.alphanumeric(32),
        expires_in: 2.hours.from_now,
        refresh_expires_in: 1.week.from_now
      )
    end
  end
end
