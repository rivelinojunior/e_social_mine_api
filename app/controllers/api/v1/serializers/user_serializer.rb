# frozen_string_literal: true

module Api
  module V1
    module Serializers
      class UserSerializer < ActiveModel::Serializer
        attributes :id, :full_name, :username, :email, :created_at, :updated_at
      end
    end
  end
end
