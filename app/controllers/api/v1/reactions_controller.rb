# frozen_string_literal: true

module Api
  module V1
    class ReactionsController < BaseController
      def create
        user_id = current_user.id
        post_id = params[:post_id]
        kind = reaction_params[:kind]

        case Reactions::CreateReactionCommand.call(kind:, user_id:, post_id:)
        in Result::Success(:created, {reaction:})
          render json: reaction, status: :created, serializer: Serializers::ReactionSerializer
        in Result::Failure(:invalid_record, {errors:})
          render json: { errors: }, status: :unprocessable_entity
        end
      end

      private

      def reaction_params
        params.permit(:kind)
      end
    end
  end
end
