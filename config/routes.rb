require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users

  root "pages#index"

  resource :webhooks, only: [] do
    collection do
      post :success, :failure, to: "webhooks#import_data"
    end

    post 'destroy', to: 'webhooks#destroy'
  end

  resources :connections, only: %i[create destroy] do
    member do
      post :refresh
      post :reconnect
    end

    resources :accounts, only: %i[index] do
      resources :transactions, only: %i[index]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  mount Sidekiq::Web => '/sidekiq'
end
