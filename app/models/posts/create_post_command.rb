# frozen_string_literal: true

module Posts
  class CreatePostCommand < ApplicationCommand
    def initialize(content:, user_id:)
      self.content = content
      self.user_id = user_id
    end

    def call
      hashtags = extract_hashtags(content)

      post = Post.create!(content:, user_id:, hashtags:)

      Result::Success(:created, post:)
    rescue ActiveRecord::RecordInvalid => e
      Result::Failure(:invalid_record, errors: e.record.errors.full_messages)
    end

    private

    attr_accessor :content, :user_id

    def extract_hashtags(content)
      hashtags = content.scan(/#\w+/).map { |hashtag| hashtag.delete_prefix('#') }.compact.uniq

      hashtags.presence
    end
  end
end
