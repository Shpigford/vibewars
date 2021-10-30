require 'sidekiq/web'

Rails.application.routes.draw do
  get '/(*path)', to: redirect { |path_params, request|
          "https://vibewars.lol/#{path_params[:path]}"
        },
  status: 301,
  constraints: { domain: 'vibewars-production.onrender.com' }


  mount Sidekiq::Web => "/sidekiq"

  resources :collections do
    resources :assets
    member do
      get 'ranking'
      get 'leaderboard'
    end
  end

  resources :votes

  get '/votes/:winner/:loser', to: 'votes#battle', as: 'votes_battle'

  get '/search', to: 'pages#search', as: 'search'
  get '/leaderboard', to: 'pages#leaderboard', as: 'leaderboard'
  get '/submit-project', to: 'pages#submit', as: 'submit'

  root "collections#index"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Almost every application defines a route for the root path ("/") at the top of this file.
  # root "articles#index"
end
