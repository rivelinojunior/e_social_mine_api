# frozen_string_literal: true

module Auth
  class CurrentSessionQuery < ApplicationQuery
    def initialize(token:)
      self.token = token
    end

    def query
      session = Session.find_by!(token:)

      return Result::Failure(:expired, errors: ['session expired']) if expired?(session.expires_in)

      Result::Success(:ok, session:, user: session.user)
    rescue ActiveRecord::RecordNotFound => e
      Result::Failure(:not_found, errors: [e.message])
    end

    private

    attr_accessor :token

    def expired?(expires_in) = Time.current > expires_in
  end
end
