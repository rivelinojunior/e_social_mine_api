# frozen_string_literal: true

module Relationships
  class FollowUserCommand < ApplicationCommand
    def initialize(follower_id:, followee_id:)
      self.follower_id = follower_id
      self.followee_id = followee_id
    end

    def call
      Relationship.create!(follower_id:, followee_id:)

      Result::Success(:created)
    rescue ActiveRecord::RecordInvalid => e
      Result::Failure(:invalid_record, errors: e.record.errors.full_messages)
    end

    private

    attr_accessor :follower_id, :followee_id
  end
end
