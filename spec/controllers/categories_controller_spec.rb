# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoriesController do
  let(:admin) { create(:user, :admin) }

  describe 'GET #index' do
    before do
      session[:user_id] = admin.id
    end

    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      session[:user_id] = admin.id
      get :new
      expect(response).to be_successful
    end

    context 'when user is not an admin' do
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
        get :new
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('You are not authorized to view this page')
      end
    end
  end

  describe 'GET #edit' do
    let(:category) { create(:category) }

    it 'returns a successful response' do
      session[:user_id] = admin.id
      get :edit, params: { id: category.id }
      expect(response).to be_successful
    end

    context 'when user is not an admin' do
      let(:user) { create(:user) }
      let(:category) { create(:category) }

      before do
        session[:user_id] = user.id
        get :edit, params: { id: category.id }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('You are not authorized to view this page')
      end
    end
  end

  describe 'POST #create' do
    let(:category_params) { attributes_for(:category) }

    before do
      session[:user_id] = admin.id
    end

    it 'creates a new category' do
      expect do
        post :create, params: { category: category_params }
      end.to change(Category, :count).by(1)
    end

    it 'redirects to the categories index' do
      post :create, params: { category: category_params }
      expect(response).to redirect_to(categories_path)
    end

    it 'sets the flash notice message' do
      post :create, params: { category: category_params }
      expect(flash[:notice]).to eq('Category was successfully created!')
    end

    context 'when user is not an admin' do
      let(:user) { create(:user) }
      let(:category_params) { attributes_for(:category) }

      before do
        session[:user_id] = user.id
        post :create, params: { category: category_params }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('You are not authorized to view this page')
      end

      it 'does not create a new category' do
        expect(Category.count).to eq(0)
      end
    end
  end

  describe 'PATCH #update' do
    let(:category) { create(:category) }
    let(:updated_name) { 'Updated Category' }
    let(:updated_params) { { name: updated_name } }

    before do
      session[:user_id] = admin.id
    end

    it 'updates the category' do
      patch :update, params: { id: category.id, category: updated_params }
      category.reload
      expect(category.name).to eq(updated_name)
    end

    it 'redirects to the categories index' do
      patch :update, params: { id: category.id, category: updated_params }
      expect(response).to redirect_to(categories_path)
    end

    it 'sets the flash notice message' do
      patch :update, params: { id: category.id, category: updated_params }
      expect(flash[:notice]).to eq('Category was successfully updated!')
    end

    context 'when user is not an admin' do
      let(:user) { create(:user) }
      let(:category) { create(:category) }
      let(:updated_name) { 'Updated Category' }
      let(:updated_params) { { name: updated_name } }

      before do
        session[:user_id] = user.id
        patch :update, params: { id: category.id, category: updated_params }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('You are not authorized to view this page')
      end

      it 'does not update the category' do
        category.reload
        expect(category.name).not_to eq(updated_name)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:category) { create(:category) }

    before do
      session[:user_id] = admin.id
    end

    it 'destroys the category' do
      expect do
        delete :destroy, params: { id: category.id }
      end.to change(Category, :count).by(-1)
    end

    it 'redirects to the categories index' do
      delete :destroy, params: { id: category.id }
      expect(response).to redirect_to(categories_path)
    end

    it 'sets the flash notice message' do
      delete :destroy, params: { id: category.id }
      expect(flash[:notice]).to eq('Category was successfully deleted!')
    end

    context 'when user is not an admin' do
      let(:user) { create(:user) }
      let!(:category) { create(:category) }

      before do
        session[:user_id] = user.id
        delete :destroy, params: { id: category.id }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('You are not authorized to view this page')
      end

      it 'does not destroy the category' do
        expect(Category.count).to eq(1)
      end
    end
  end
end
