# frozen_string_literal: true

module Api
  module V1
    class PostsController < BaseController
      def create
        case Posts::CreatePostCommand.call(content: post_params['content'], user_id: current_user.id)
        in Result::Success(post:)
          render json: post, status: :created, serializer: Serializers::PostSerializer
        in Result::Failure(errors:)
          render json: { errors: }, status: :unprocessable_entity
        end
      end

      private

      def post_params
        params.permit(:content)
      end
    end
  end
end
