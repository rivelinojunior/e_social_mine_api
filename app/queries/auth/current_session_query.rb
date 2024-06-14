# frozen_string_literal: true

module Auth
  class CurrentSessionQuery < ApplicationQuery
    def initialize(token:)
      self.token = token
    end

    def query
      session = Session.find_by!(token:)

      return Result::Success(:ok, session:, user: session.user) unless expired?(session.expires_in)

      Result::Failure(:expired, errors: ['session expired'])
    rescue ActiveRecord::RecordNotFound => e
      Result::Failure(:not_found, errors: [e.message])
    end

    private

    attr_accessor :token

    def expired?(expires_in) = Time.current > expires_in
  end
end
