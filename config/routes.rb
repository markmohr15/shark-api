Rails.application.routes.draw do
  devise_for :users, skip: :sessions
  post "/graphql", to: "graphql#execute"

  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  mount Sidekiq::Web => '/sidekiq'
  
end
