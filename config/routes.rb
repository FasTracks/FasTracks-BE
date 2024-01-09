require "sidekiq/web"

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post "/api/v1/playlists", to: "api/v1/playlists#generate"

  mount Sidekiq::Web => "/sidekiq"
end
