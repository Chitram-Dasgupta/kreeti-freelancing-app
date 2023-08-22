# frozen_string_literal: true

RSpec.describe WelcomeController do
  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to be_successful
    end

    it 'does not redirect' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end
