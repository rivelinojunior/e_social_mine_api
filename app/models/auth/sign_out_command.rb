# frozen_string_literal: true

module Auth
  class SignOutCommand < ApplicationCommand
    def initialize(params:)
      self.params = params
    end

    def call
      session = Session.find_by!(token: params[:token])
      session.destroy!

      Result::Success(:ok)
    end

    private

    attr_accessor :params
  end
end
