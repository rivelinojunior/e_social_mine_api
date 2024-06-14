# frozen_string_literal: true

module Api
  module V1
    class SignOutController < BaseController
      def destroy
        Auth::SignOutCommand.call(params: { token: current_session.token })

        head :ok
      end
    end
  end
end
