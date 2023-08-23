# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomsController do
  let(:current_user) { create(:user) }
  let(:category) { create(:category) }
  let(:other_user) { create(:user, :freelancer, categories: [category]) }
  let(:admin_user) { create(:user, role: 'admin') }

  describe 'GET #index' do
    context 'when user is logged in' do
      before { session[:user_id] = current_user.id }

      it 'does not allow admin users to access the index' do
        session[:user_id] = admin_user.id
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the login page' do
        get :index
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'GET #show' do
    context 'when user is logged in but does not have access' do
      let(:current_user) { create(:user) }
      let(:room) { create(:room) }

      before do
        session[:user_id] = current_user.id
      end

      it 'redirects to root path' do
        get :show, params: { id: room.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      let(:room) { create(:room) }

      it 'redirects to the login page' do
        get :show, params: { id: room.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is logged in' do
      before { session[:user_id] = current_user.id }

      it 'creates a new room' do
        expect { post :create, params: { user_id: other_user.id } }.to change(Room, :count).by(1)
      end

      it 'redirects to the created room' do
        post :create, params: { user_id: other_user.id }
        expect(response).to redirect_to(Room.last)
      end

      it 'redirects to root when attempting to create a room with invalid users' do
        post :create, params: { user_id: admin_user.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the login page' do
        post :create, params: { user_id: other_user.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
