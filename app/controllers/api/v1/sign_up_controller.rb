# frozen_string_literal: true

module Api
  module V1
    class SignUpController < ApplicationController
      def create
        case Users::SignUpCommand.call(params: user_params)
        in Result::Success(user:)
          render json: user, status: :created, serializer: Serializers::UserSerializer
        in Result::Failure(errors:)
          render json: { errors: }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :username, :full_name).to_h
      end
    end
  end
end
