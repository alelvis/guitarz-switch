Rails.application.routes.draw do
  devise_for :users
  root to: "guitars#index"

  resources :guitars, except: :index

end
