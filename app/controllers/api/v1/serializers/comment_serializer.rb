# frozen_string_literal: true

module Api
  module V1
    module Serializers
      class CommentSerializer < ActiveModel::Serializer
        attributes :id, :message, :post_id, :user_id, :created_at
        attribute :user

        def user
          {
            username: object.user.username,
            full_name: object.user.full_name
          }
        end
      end
    end
  end
end
