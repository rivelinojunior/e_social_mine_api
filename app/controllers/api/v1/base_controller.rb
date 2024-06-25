# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :authenticate!

      private

      attr_accessor :current_user, :current_session

      def authenticate!
        authenticate_with_http_token do |token, _options|
          session, user = query_session(token)

          self.current_user = user
          self.current_session = session
        end

        return if current_session && current_user

        render json: { errors: ['invalid session token'] }, status: :unauthorized
      end

      def query_session(token)
        @query_session ||=
          case ::Auth::CurrentSessionQuery.query(token:)
          in Result::Success(session:, user:)
            [session, user]
          in Result::Failure
            [nil, nil]
          end
      end
    end
  end
end
