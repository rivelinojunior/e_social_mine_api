# frozen_string_literal: true

module Api
  module V1
    module Serializers
      class ReactionSerializer < ActiveModel::Serializer
        attributes :id, :kind, :user_id, :post_id, :created_at
        attribute :user

        def user
          {
            email: object.user.email,
            username: object.user.username,
            full_name: object.user.full_name
          }
        end
      end
    end
  end
end
