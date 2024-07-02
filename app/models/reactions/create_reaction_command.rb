# frozen_string_literal: true

module Reactions
  class CreateReactionCommand < ApplicationCommand
    def initialize(kind:, user_id:, post_id:)
      self.kind = kind
      self.user_id = user_id
      self.post_id = post_id
    end

    def call
      reaction = Reaction.create!(kind:, user_id:, post_id:)

      Result::Success(:created, reaction:)
    rescue ActiveRecord::RecordInvalid => e
      Result::Failure(:invalid_record, errors: e.record.errors.full_messages)
    rescue ArgumentError => e
      Result::Failure(:invalid_record, errors: [e.message])
    end

    private

    attr_accessor :kind, :user_id, :post_id
  end
end
