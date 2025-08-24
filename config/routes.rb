Rails.application.routes.draw do
  devise_for :users
  root to: 'projects#index'

  resources :projects do
    member do
      patch :complete_all_tasks
    end
    resources :tasks, only: [:new, :create]
  end

  resources :tasks, only: [:index, :show, :update, :destroy]
end
