Rails.application.routes.draw do
  get "tasks/index"
  get "tasks/show"
  get "tasks/new"
  get "tasks/create"
  get "tasks/update"
  get "tasks/destroy"
  get "projects/index"
  get "projects/create"
  get "projects/new"
  get "projects/edit"
  get "projects/show"
  get "projects/update"
  get "projects/destroy"
  devise_for :users
  root to: "projects#index"

  resources :projects do
    resources :tasks, only: [:new, :create]
  end

  resources :tasks, only: [:index, :show, :update, :destroy]
end
