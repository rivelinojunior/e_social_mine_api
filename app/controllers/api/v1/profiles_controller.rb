# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < BaseController
      def update
        command_result = Profile::UpdateUserProfileCommand.call(
          user_id: current_user.id, full_name: user_params[:full_name], username: user_params[:username]
        )

        case command_result
        in Result::Success(:updated, {user:})
          render json: user, status: :ok, serializer: Serializers::UserSerializer
        in Result::Failure(:invalid_record, {errors:})
          render json: { errors: }, status: :unprocessable_entity
        end
      end

      private

      def user_params = params.permit(:full_name, :username)
    end
  end
end
