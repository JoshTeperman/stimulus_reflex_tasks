Rails.application.routes.draw do
  get 'lists/index'
  resources :lists, only: [:index]
  root to: 'lists#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
