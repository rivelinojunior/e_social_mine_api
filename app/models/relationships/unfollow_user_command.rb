# frozen_string_literal: true

module Relationships
  class UnfollowUserCommand < ApplicationCommand
    def initialize(follower_id:, followee_id:)
      self.follower_id = follower_id
      self.followee_id = followee_id
    end

    def call
      Relationship.find_by!(follower_id:, followee_id:)
                  .destroy!

      Result::Success(:ok)
    rescue ActiveRecord::RecordNotFound => e
      Result::Failure(:not_found, errors: [e.message])
    end

    private

    attr_accessor :follower_id, :followee_id
  end
end
