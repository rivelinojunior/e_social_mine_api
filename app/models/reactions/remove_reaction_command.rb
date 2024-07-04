# frozen_string_literal: true

module Reactions
  class RemoveReactionCommand < ApplicationCommand
    def initialize(id:)
      self.id = id
    end

    def call
      Reaction.find(id)
              .destroy!

      Result::Success(:ok)
    rescue ActiveRecord::RecordNotFound => e
      Result::Failure(:not_found, errors: [e.message])
    end

    private

    attr_accessor :id
  end
end
