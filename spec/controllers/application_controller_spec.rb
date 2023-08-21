# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController do
  let(:user) { create(:user) }

  describe '#current_user' do
    context 'when user is logged in' do
      before do
        session[:user_id] = user.id
      end

      it 'returns the current user' do
        expect(controller.current_user).to eq(user)
      end
    end

    context 'when user is not logged in' do
      it 'returns nil' do
        expect(controller.current_user).to be_nil
      end
    end
  end

  describe '#logged_in?' do
    context 'when user is logged in' do
      before do
        session[:user_id] = user.id
      end

      it 'returns true' do
        expect(controller.logged_in?).to be true
      end
    end

    context 'when user is not logged in' do
      it 'returns false' do
        expect(controller.logged_in?).to be false
      end
    end
  end

  describe '#admin?' do
    context 'when user is an admin' do
      let(:user) { create(:user, role: 'admin') }

      before do
        session[:user_id] = user.id
      end

      it 'returns true' do
        expect(controller.admin?).to be true
      end
    end

    context 'when user is not an admin' do
      let(:user) { create(:user, role: 'client') }

      before do
        session[:user_id] = user.id
      end

      it 'returns false' do
        expect(controller.admin?).to be false
      end
    end
  end

  describe '#client?' do
    context 'when user is a client' do
      let(:user) { create(:user, role: 'client') }

      before do
        session[:user_id] = user.id
      end

      it 'returns true' do
        expect(controller.client?).to be true
      end
    end

    context 'when user is not a client' do
      let(:user) { create(:user, role: 'admin') }

      before do
        session[:user_id] = user.id
      end

      it 'returns false' do
        expect(controller.client?).to be false
      end
    end
  end

  describe '#freelancer?' do
    context 'when user is a freelancer' do
      let(:user) { create(:user, :freelancer) }

      before do
        session[:user_id] = user.id
      end

      it 'returns true' do
        expect(controller.freelancer?).to be true
      end
    end

    context 'when user is not a freelancer' do
      let(:user) { create(:user, role: 'client') }

      before do
        session[:user_id] = user.id
      end

      it 'returns false' do
        expect(controller.freelancer?).to be false
      end
    end
  end

  describe '#require_admin' do
    controller do
      before_action :require_admin

      def index
        render plain: 'Hello'
      end
    end

    context 'when user is an admin' do
      let(:user) { create(:user, :admin) }

      before do
        session[:user_id] = user.id
        get :index
      end

      it 'does not redirect' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not an admin' do
      let(:user) { create(:user, :client) }

      before do
        session[:user_id] = user.id
        get :index
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#require_authorization' do
    controller do
      before_action :require_authorization

      def index
        render plain: 'Hello'
      end
    end

    context 'when user is logged in' do
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
        get :index
      end

      it 'does not redirect' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not logged in' do
      before do
        get :index
      end

      it 'redirects to new_session_path' do
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe '#redirect_logged_in_users' do
    controller do
      before_action :redirect_logged_in_users

      def new
        render plain: 'Hello'
      end
    end

    context 'when user is logged in' do
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
        get :new
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#render_not_found' do
    controller do
      def show
        raise ActionController::RoutingError, 'Not Found'
      rescue ActionController::RoutingError
        render_not_found
      end
    end

    before do
      get :show, params: { id: 'unknown' }
    end

    it 'redirects to root_path' do
      expect(response).to redirect_to(new_session_path)
    end
  end
end
