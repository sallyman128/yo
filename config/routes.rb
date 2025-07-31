Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Devise routes
  devise_for :users

  # Root route - welcome for guests, home for authenticated users
  root "welcome#index"

  # Settings
  get "settings", to: "settings#index"

  # Friendships
  resources :friendships, only: [:index, :create, :destroy] do
    member do
      patch :accept
      patch :reject
    end
  end

  # Push notifications
  resources :push_notifications, only: [:create] do
    collection do
      post :send_notification
    end
  end

  # API routes for push notifications
  namespace :api do
    namespace :v1 do
      resources :push_subscriptions, only: [:create, :destroy]
      resources :notifications, only: [:create]
    end
  end
end
