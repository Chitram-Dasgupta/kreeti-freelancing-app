Rails.application.routes.draw do
  resources :sessions, only: %i[new create destroy]
  # get 'login_verify', to: 'sessions#activation'
  resources :users, only: %i[new create show edit update]
  resources :users do
    member do
      get :confirm_email, to: 'users#confirm_email'
    end
  end
  root 'welcome#index'
end
