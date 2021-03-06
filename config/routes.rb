Rails.application.routes.draw do
  devise_for :users
  resources :lists, only: [:index, :new, :create, :destroy] do
    resources :tasks, only: [:show] do
      resources :comments, only: [:create]
    end
  end
  root to: 'lists#index'
end
