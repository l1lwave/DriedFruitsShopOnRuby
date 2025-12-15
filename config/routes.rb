Rails.application.routes.draw do
  root "products#index"

  resources :products
  resources :orders, only: [ :index, :new, :create ]
  resources :users, only: [ :new, :create ]

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
end
