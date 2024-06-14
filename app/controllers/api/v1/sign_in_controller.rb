# frozen_string_literal: true

module Api
  module V1
    class SignInController < BaseController
      skip_before_action :authenticate!

      def create
        case Auth::SignInCommand.call(params: auth_params)
        in Result::Success(session:)
          render json: session, status: :ok, serializer: Serializers::SessionSerializer
        in Result::Failure
          render json: { errors: ['invalid credentials'] }, status: :unauthorized
        end
      end

      private

      def auth_params
        params.permit(:email, :password).to_h
      end
    end
  end
end
