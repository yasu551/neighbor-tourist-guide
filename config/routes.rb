Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'log_out', to: 'sessions#destroy', as: 'log_out'
  resources :places, param: :uuid
  resources :diaries, only: [:index, :show, :new, :create]
  root 'home#index'
end
