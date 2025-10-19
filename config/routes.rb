Rails.application.routes.draw do
  devise_for :users

  root "projects#index" # <--- AJOUT CRITIQUE

  resources :projects do
    member { patch :complete_all_tasks }
    resources :tasks, only: [:new, :create]
  end

  resources :tasks do
    member do
      patch :reorder
      patch :toggle_complete
    end
  end
end
