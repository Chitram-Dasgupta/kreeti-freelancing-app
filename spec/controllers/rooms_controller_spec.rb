# frozen_string_literal: true

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
      before do
        session[:user_id] = current_user.id
        @room = create(:room)
      end

      it 'redirects to root path with an error message' do
        get :show, params: { id: @room.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to be_present
      end
    end

    context 'when user is not logged in' do
      before do
        @room = create(:room)
      end

      it 'redirects to the login page' do
        get :show, params: { id: @room.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is logged in' do
      before { session[:user_id] = current_user.id }

      it 'creates a new room and redirects to it' do
        expect { post :create, params: { user_id: other_user.id } }.to change(Room, :count).by(1)
        expect(response).to redirect_to(Room.last)
      end

      it 'redirects to root when attempting to create a room with invalid users' do
        post :create, params: { user_id: current_user.id }
        expect(response).to redirect_to(root_path)

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
