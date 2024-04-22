Rails.application.routes.draw do
  devise_for :users, skip: :sessions
  post "/graphql", to: "graphql#execute"
  CaesarsController.action_methods.each do |action|
    get "caesars/#{action}", to: "caesars##{action}"
  end
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  mount Sidekiq::Web => '/sidekiq'
  
end

