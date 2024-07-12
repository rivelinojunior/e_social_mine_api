# frozen_string_literal: true

module Posts
  class RemoveCommentCommand < ApplicationCommand
    def initialize(id:)
      self.id = id
    end

    def call
      Comment.find(id)
             .destroy!

      Result::Success(:ok)
    rescue ActiveRecord::RecordNotFound => e
      Result::Failure(:not_found, errors: [e.message])
    end

    private

    attr_accessor :id
  end
end
