Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/api/v1/genres", to: "api/v1/genres#index"
  get "/api/v1/songs", to: "api/v1/songs#index"
end
