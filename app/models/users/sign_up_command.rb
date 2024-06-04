# frozen_string_literal: true

module Users
  class SignUpCommand < ApplicationCommand
    def initialize(params:)
      self.params = params
    end

    def call
      user = User.create!(
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation],
        username: params[:username],
        full_name: params[:full_name]
      )

      Result::Success(:created, user:)
    rescue ActiveRecord::RecordInvalid => e
      Result::Failure(:invalid_record, errors: e.record.errors.full_messages)
    end

    private

    attr_accessor :params
  end
end
