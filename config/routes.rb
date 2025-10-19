Rails.application.routes.draw do
  devise_for :users

  resources :projects do
    member { patch :complete_all_tasks }
    resources :tasks, only: [:new, :create]
  end

  resources :tasks do
    member do
      patch :reorder
      # Nous ajoutons 'as: :task_toggle_complete' pour garantir le nom du helper path
      patch :toggle_complete, as: :toggle_complete
    end
  end

  # Ajoutez la route racine ici si elle n'y est pas
  # root "projects#index"
end
