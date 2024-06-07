Rails.application.routes.draw do
  resources :places, param: :uuid
  root 'home#index'
end
