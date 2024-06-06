# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :sign_up, only: :create
      resources :sign_in, only: :create
    end
  end
end
