Rails.application.routes.draw do
  resources :sessions, only: %i[new create destroy]

  resources :users, except: %i[index destroy] do
    get :confirm_email, to: 'users#confirm_email', on: :member
    get :search, to: 'users#search', on: :collection
  end

  resources :projects

  resources :bids do
    member do
      post 'accept'
      post 'reject'
      post 'hold'
      post 'award'
    end
  end

  root 'welcome#index'
end
