Rails.application.routes.draw do
  devise_for :users
  resources :lists, only: [:index, :new, :create, :destroy]
  resources :tasks, only: [:create]
  root to: 'lists#index'
end
