require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  resources :collections do
    member do
      get 'ranking'
    end
  end

  resources :votes

  get '/votes/:winner/:loser', to: 'votes#battle', as: 'votes_battle'

  root "collections#index"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Almost every application defines a route for the root path ("/") at the top of this file.
  # root "articles#index"
end
