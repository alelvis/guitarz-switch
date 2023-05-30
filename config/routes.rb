Rails.application.routes.draw do
  devise_for :users
  root to: "guitars#index"

  resources :guitars, except: :index

  get '/my_listings', to: 'guitars#my_guitars', as: :my_guitars
  get '/my_rentals', to: 'orders#my_rentals', as: :my_rentals
end
