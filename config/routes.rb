require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  resources :collections do
    resources :assets do
    member do
      get 'direct'
      get 'redirect'
    end
    end
    member do
      get 'ranking'
      get 'leaderboard'
    end
  end

  resources :votes
  resources :wallets
  resources :admin

  get '/votes/:winner/:loser', to: 'votes#battle', as: 'votes_battle'

  get '/search', to: 'pages#search', as: 'search'
  get '/leaderboard', to: 'pages#leaderboard', as: 'leaderboard'
  get '/submit-project', to: 'pages#submit', as: 'submit'
  get '/giveaway', to: 'pages#giveaway', as: 'giveaway'

  root "collections#index"

  post "/session", to: "session#create"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Almost every application defines a route for the root path ("/") at the top of this file.
  # root "articles#index"
end
