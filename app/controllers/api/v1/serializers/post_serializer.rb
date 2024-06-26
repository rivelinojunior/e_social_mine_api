# frozen_string_literal: true

module Api
  module V1
    module Serializers
      class PostSerializer < ActiveModel::Serializer
        attributes :id, :content, :user_id, :hashtags, :created_at
      end
    end
  end
end
