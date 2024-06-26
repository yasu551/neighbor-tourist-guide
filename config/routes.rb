Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'log_out', to: 'sessions#destroy', as: 'log_out'
  resources :places, param: :uuid
  resources :users, only: [] do
    scope module: :users do
      resources :visited_places, only: %i[index create]
    end
  end
  root 'home#index'
end
