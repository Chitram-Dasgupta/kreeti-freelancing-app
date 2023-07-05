# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  resources :rooms, only: %i[index show create] do
    resources :messages, only: %i[create]
  end

  resources :notifications do
    collection do
      get 'count'
      get 'fetch_notifications'
      post 'mark_all_as_read'
      post 'delete_read'
    end
    post 'mark_as_read', on: :member
  end

  resources :sessions, only: %i[index new create destroy]

  resources :users do
    get :confirm_email, to: 'users#confirm_email', on: :member
    get :search, to: 'users#search', on: :collection
  end

  resources :projects do
    get :search, to: 'projects#search', on: :collection
  end

  resources :bids do
    member do
      post 'accept'
      post 'reject'
      post 'hold'
      post 'award'
    end
  end

  resources :categories

  root 'welcome#index'
end
# rubocop:enable Metrics/BlockLength
