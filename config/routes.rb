# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        resource :sign_up, only: :create, controller: :sign_up
        resource :sign_in, only: :create, controller: :sign_in
        resource :sign_out, only: :destroy, controller: :sign_out
      end

      resources :posts, only: :create
    end
  end
end
