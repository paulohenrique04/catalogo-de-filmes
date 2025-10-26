Rails.application.routes.draw do
  get "categories/index"
  get "categories/new"
  get "categories/create"
  get "comments/create"
  resources :movies do
    resources :comments, only: [:create, :destroy]
    collection do
      get 'fetch_ai_data'
    end
  end

  resources :categories
  devise_for :users
  
  get "up" => "rails/health#show", as: :rails_health_check

  get '/locale/:locale', to: 'application#change_locale', as: 'set_locale'

  # Defines the root path route ("/")
  root "movies#index"
end
