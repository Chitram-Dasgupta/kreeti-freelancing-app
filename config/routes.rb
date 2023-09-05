# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  resources :rooms, only: %i[index show create] do
    resources :messages, only: %i[create]
  end

  resources :notifications, only: [] do
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
    get :search, controller: 'users', action: 'search', on: :collection
  end

  resources :projects do
    get :search, controller: 'projects', action: 'search', on: :collection
  end

  resources :bids do
    member do
      post 'accept'
      post 'reject'
      patch 'files_upload'
    end
  end

  scope '/admin' do
    resources :categories, except: %i[show]

    resources :users do
      get :manage_registrations, controller: 'users', action: 'manage_registrations', on: :collection

      member do
        get :confirm_email, controller: 'users', action: 'confirm_email'
        post :approve
        post :reject
      end
    end
  end

  root 'welcome#index'

  match '*path', controller: 'application', action: 'render_not_found', constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }, via: :all
end
# rubocop:enable Metrics/BlockLength
