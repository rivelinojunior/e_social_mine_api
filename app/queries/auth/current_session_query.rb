# frozen_string_literal: true

module Auth
  class CurrentSessionQuery < ApplicationQuery
    def initialize(token:)
      self.token = token
    end

    def query
      session = Session.find_by!(token:)

      Result::Success(:ok, session:, user: session.user)
    rescue ActiveRecord::RecordNotFound => e
      Result::Failure(:not_found, errosr: [e.message])
    end

    private

    attr_accessor :token
  end
end
