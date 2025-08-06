Rails.application.routes.draw do
  devise_for :users
  root to: 'projects#index'

  resources :projects do
    resources :tasks, only: [:new, :create]
  end

  resources :tasks, only: [:index, :show, :update, :destroy]
end
