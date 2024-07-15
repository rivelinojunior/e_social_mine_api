# frozen_string_literal: true

module Profile
  class UpdateUserProfileCommand < ApplicationCommand
    def initialize(user_id:, full_name:, username:)
      self.user_id = user_id
      self.full_name = full_name
      self.username = username
    end

    def call
      user = User.find(user_id)
      user.update!(full_name:, username:)

      Result::Success(:updated, user:)
    rescue ActiveRecord::RecordNotFound => e
      Result::Failure(:not_found, errors: [e.message])
    rescue ActiveRecord::RecordInvalid => e
      Result::Failure(:invalid_record, errors: e.record.errors.full_messages)
    end

    private

    attr_accessor :user_id, :full_name, :username
  end
end
