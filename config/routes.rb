Rails.application.routes.draw do
  resources :profiles, only: %i[show edit update]

  resources :sessions, only: %i[new create destroy]

  resources :users, only: %i[new create show edit update]
  resources :users do
    get :confirm_email, to: 'users#confirm_email', on: :member
  end

  resources :projects

  root 'welcome#index'
end
