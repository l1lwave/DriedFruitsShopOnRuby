
Rails.application.routes.draw do
  # Ресурсні маршрути (створюють CRUD-дії, включаючи правильний POST для create)
  resources :products
  resources :categories
  resources :users, only: [ :new, :create, :edit, :update, :show, :destroy ]

  # Кошик та елементи кошика (Cart - show/destroy; LineItems - create/destroy)
  resources :carts, only: [ :show, :destroy ]
  resources :line_items, only: [ :create, :destroy ]

  # Замовлення (Orders - index, show, new, create)
  resources :orders, only: [ :index, :show, :new, :create ]

  # Вибране
  resources :favorites, only: [ :index, :create, :destroy ]

  resources :products do
    resources :reviews, only: [ :create, :destroy ]
  end

  resources :callback_requests, only: [ :create ]

  namespace :admin do
    get "orders/index"
    get "orders/show"
    get "orders/destroy"
    resources :callback_requests, only: [ :index, :destroy ]
  end

  namespace :admin do
    resources :orders, only: [ :index, :show, :update, :destroy ] do
      member do
        patch :update_status
      end
    end
    root to: "orders#index"
  end

  # Маршрути для аутентифікації
  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  root "products#index"
end
