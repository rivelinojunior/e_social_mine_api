# frozen_string_literal: true

module Api
  module V1
    module Serializers
      class SessionSerializer < ActiveModel::Serializer
        attributes :user_id, :token, :refresh_token, :expires_in, :refresh_expires_in, :created_at
        attribute :email

        def email = object.user.email
      end
    end
  end
end
