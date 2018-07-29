Rails.application.routes.draw do
  devise_for :users
  root 'movies#index'

  resources :movies do
    member do
      post :join
      post :quit
    end
    resources :reviews
  end
  
end
