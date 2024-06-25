# frozen_string_literal: true

module Posts
  class CreatePostCommand < ApplicationCommand
    def initialize(content:, user_id:)
      self.content = content
      self.user_id = user_id
    end

    def call
      post = Post.create!(content:, user_id:)

      Result::Success(:created, post:)
    rescue ActiveRecord::RecordInvalid => e
      Result::Failure(:invalid_record, errors: e.record.errors.full_messages)
    end

    private

    attr_accessor :content, :user_id
  end
end
