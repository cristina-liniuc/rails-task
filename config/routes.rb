Rails.application.routes.draw do
  resources :transactions
  resources :accounts
  # get 'home/index'
  root to: "home#index"
  resources :connections do
    collection do
      get 'fetch_connections'
    end
  end
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
