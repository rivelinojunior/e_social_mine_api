# frozen_string_literal: true

module Api
  module V1
    class RelationshipsController < BaseController
      def create
        follower_id = current_user.id
        followee_id = relationship_params[:followee_id]

        case Relationships::FollowUserCommand.call(follower_id:, followee_id:)
        in Result::Success(type: :created)
          head :created
        in Result::Failure(:invalid_record, {errors:})
          render json: { errors: }, status: :unprocessable_entity
        end
      end

      private

      def relationship_params
        params.permit(:followee_id)
      end
    end
  end
end
