Rails.application.routes.draw do
  devise_for :users
  root to: "guitars#index"

  resources :guitars, except: :index do
    resources :orders, only: :create
  end

  resources :orders, only: %i[show destroy]

  get '/my_listings', to: 'guitars#my_guitars', as: :my_guitars
  get '/my_listings/order_history', to: 'orders#my_sales', as: :my_sales

  get '/my_rentals', to: 'orders#my_purchases', as: :my_purchases
end
