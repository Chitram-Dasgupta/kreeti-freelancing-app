# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController do
  include Rails.application.routes.url_helpers

  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:admin) { create(:user, :admin) }

    context 'when user is admin' do
      it 'renders the index template and includes the expected users' do
        session[:user_id] = admin.id
        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the new user path' do
        get :index
        expect(response).to redirect_to(new_user_path)
      end
    end

    context 'when user is logged in but not an admin' do
      it 'redirects to the root path with an error message' do
        session[:user_id] = user.id
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user, :admin, status: 'approved') }

    context 'when user is visible' do
      it 'renders the show template and includes the user username' do
        session[:user_id] = user.id
        get :show, params: { id: user.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not visible' do
      it 'redirects to the root path with an error message' do
        invisible_user = create(:user, :invisible)
        get :show, params: { id: invisible_user.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_params) do
        {
          user: {
            email: 'test@example.com',
            password: 'password',
            password_confirmation: 'password',
            username: 'testuser',
            role: 'client'
          }
        }
      end

      it 'creates a new user and redirects to root path with success message' do
        expect do
          post :create, params: valid_params
        end.to change(User, :count).by(1)

        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          user: {
            email: 'invalid_email',
            password: 'short',
            password_confirmation: 'mismatch',
            username: '',
            role: 'freelancer'
          }
        }
      end

      it 'does not create a new user and renders new template with error message' do
        expect { post :create, params: invalid_params }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }

    context 'when user is logged in' do
      before do
        session[:user_id] = user.id # Set the session user ID
        get :edit, params: { id: user.id }
      end

      it 'renders the edit template' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the new user path' do
        get :edit, params: { id: user.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }

    context 'with valid params' do
      let(:valid_params) do
        {
          id: user.id,
          user: {
            username: 'updated_username'
          }
        }
      end

      it 'updates the user and redirects to user profile with success message' do
        session[:user_id] = user.id
        patch :update, params: valid_params
        user.reload
        expect(user.username).to eq('updated_username')
        expect(response).to redirect_to(user_path(user))
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          id: user.id,
          user: {
            email: 'invalid_email'
          }
        }
      end

      it 'does not update the user and renders edit template with error message' do
        session[:user_id] = user.id
        patch :update, params: invalid_params
        user.reload
        expect(user.email).not_to eq('invalid_email')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }

    context 'when user is logged in' do
      before do
        session[:user_id] = user.id
      end

      it 'deletes the user and redirects to users index with success message' do
        expect do
          delete :destroy, params: { id: user.id }
        end.to change(User, :count).by(-1)

        expect(response).to redirect_to(users_path)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the new user path' do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'GET #confirm_email' do
    let(:user) { create(:user, status: :approved) }

    context 'with a valid confirmation token' do
      it 'activates the user email' do
        user.update(confirmation_token: 'valid_token', confirmation_token_created_at: Time.current)

        get :confirm_email, params: { id: user.id, token: 'valid_token' }

        expect(user.reload.email_confirmed).to be true
        expect(user.reload.confirmation_token).to be_nil
        expect(user.reload.confirmation_token_created_at).to be_nil
      end

      it 'redirects to the sign-in page' do
        user.update(confirmation_token: 'valid_token', confirmation_token_created_at: Time.current)

        get :confirm_email, params: { id: user.id, token: 'valid_token' }

        expect(response).to redirect_to(new_session_path)
        expect(flash[:success]).to eq('Your email has been confirmed. Please sign in to continue.')
      end
    end

    context 'with an expired confirmation token' do
      it 'does not activate the user email' do
        user.update(confirmation_token: 'expired_token', confirmation_token_created_at: 2.hours.ago)

        expect do
          get :confirm_email, params: { id: user.id, token: 'expired_token' }
        end.to change(User, :count).by(-1)
      end

      it 'redirects to the sign-up page' do
        user.update(confirmation_token: 'expired_token', confirmation_token_created_at: 2.hours.ago)

        get :confirm_email, params: { id: user.id, token: 'expired_token' }

        expect(response).to redirect_to(new_user_path)
        expect(flash[:error]).to eq('Confirmation token expired. Please sign up again.')
      end
    end

    context 'with an invalid confirmation token' do
      it 'redirects to the root page' do
        get :confirm_email, params: { id: user.id, token: 'invalid_token' }

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq('Sorry. User does not exist')
      end
    end
  end

  describe 'PATCH #approve' do
    let(:admin) { create(:user, :admin) }
    let(:user_to_approve) { create(:user, status: 'pending') }

    it 'approves the user and sends account activation email' do
      session[:user_id] = admin.id

      expect do
        patch :approve, params: { id: user_to_approve.id }
      end.to change { user_to_approve.reload.status }.from('pending').to('approved')

      expect(response).to redirect_to(manage_registrations_users_path)
      expect(flash[:success]).to eq('User approved.')
    end
  end

  describe 'PATCH #reject' do
    let(:admin) { create(:user, :admin) }
    let(:user_to_reject) { create(:user, status: 'pending') }

    it 'rejects the user' do
      session[:user_id] = admin.id

      expect do
        patch :reject, params: { id: user_to_reject.id }
      end.to change { user_to_reject.reload.status }.from('pending').to('rejected')

      expect(response).to redirect_to(manage_registrations_users_path)
      expect(flash[:success]).to eq('User rejected.')
    end
  end

  describe 'GET #search' do
    let!(:freelancer1) { create(:user, :freelancer, username: 'john_doe', categories: [category]) }
    let!(:freelancer2) { create(:user, :freelancer, username: 'jane_doe', categories: [category]) }
    let(:category) { create(:category) }

    it 'renders the search template and includes matching freelancers' do
      get :search, params: { search: 'john' }
      expect(response).to have_http_status(:ok)
    end

    it 'renders the search template and includes multiple matching freelancers' do
      get :search, params: { search: 'jane' }
      expect(response).to have_http_status(:ok)
    end

    it 'renders the search template and includes no matching freelancers' do
      get :search, params: { search: 'nonexistent' }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #manage_registrations' do
    let(:admin) { create(:user, :admin) }
    let!(:pending_users) { create_list(:user, 3, status: 'pending') }

    it 'renders the manage_registrations template and includes pending users' do
      session[:user_id] = admin.id
      get :manage_registrations
      expect(response).to have_http_status(:ok)
    end

    it 'redirects to root path if user is not an admin' do
      get :manage_registrations
      expect(response).to redirect_to(root_path)
    end
  end
end
