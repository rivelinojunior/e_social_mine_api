# frozen_string_literal: true

module Posts
  class CreateCommentCommand < ApplicationCommand
    def initialize(message:, user_id:, post_id:)
      self.message = message
      self.user_id = user_id
      self.post_id = post_id
    end

    def call
      comment = Comment.create!(message:, user_id:, post_id:)

      Result::Success(:created, comment:)
    rescue ActiveRecord::RecordInvalid => e
      Result::Failure(:invalid_record, errors: e.record.errors.full_messages)
    end

    private

    attr_accessor :message, :user_id, :post_id
  end
end
