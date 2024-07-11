# frozen_string_literal: true

module Api
  module V1
    class CommentsController < BaseController
      def create
        message = comment_params[:message]
        post_id = params[:post_id]
        user_id = current_user.id

        case Posts::CreateCommentCommand.call(message:, user_id:, post_id:)
        in Result::Success(comment:)
          render json: comment, status: :created, serializer: Serializers::CommentSerializer
        in Result::Failure(errors:)
          render json: { errors: }, status: :unprocessable_entity
        end
      end

      private

      def comment_params
        params.permit(:message)
      end
    end
  end
end
