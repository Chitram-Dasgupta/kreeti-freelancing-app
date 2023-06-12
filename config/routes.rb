Rails.application.routes.draw do
  resources :sessions, only: %i[new create destroy]
  resources :users, only: %i[new create show edit update]
  root 'welcome#index'
end
