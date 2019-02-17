# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1 do
    resources :tasks, only: [:index]
  end
end
