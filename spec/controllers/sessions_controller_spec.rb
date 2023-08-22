# frozen_string_literal: true

RSpec.describe SessionsController do
  describe 'GET #index' do
    it 'redirects to the login page' do
      get :index
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user, email_confirmed: true) }
    let(:valid_params) { { email: user.email, password: user.password } }

    context 'with valid credentials and confirmed email' do
      it 'sets user_id in the session' do
        post :create, params: valid_params
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'with invalid credentials' do
      it 'renders the login page with an error message' do
        post :create, params: { email: user.email, password: 'invalid_password' }
        expect(flash[:error]).to eq('Invalid credentials. Please try again')
      end
    end

    context 'with unconfirmed email' do
      it 'redirects to the root path' do
        user.update(email_confirmed: false)
        post :create, params: valid_params
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with rejected account' do
      it 'redirects to the root path' do
        user.update(email_confirmed: false, status: 'rejected')
        post :create, params: valid_params
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    before do
      session[:user_id] = user.id
      delete :destroy, params: { id: user.id }
    end

    it 'removes user_id from the session' do
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to the root path' do
      expect(response).to redirect_to(root_path)
    end
  end
end
