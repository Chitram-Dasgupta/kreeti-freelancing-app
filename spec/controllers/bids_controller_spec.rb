# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BidsController do
  describe 'GET #index' do
    context 'when user is an admin' do
      let(:admin) { create(:user, :admin) }
      let(:bids) { create_list(:bid, 3) }

      before do
        session[:user_id] = admin.id
        get :index
      end

      it 'returns a successful response' do
        expect(response).to be_successful
      end
    end

    context 'when user is a freelancer' do
      let(:category) { create(:category) }
      let(:freelancer) { create(:user, role: 'freelancer', categories: [category]) }
      let(:user_bids) { create_list(:bid, 2, user: freelancer) }

      before do
        session[:user_id] = freelancer.id
        get :index
      end

      it 'returns a successful response' do
        expect(response).to be_successful
      end
    end

    context 'when user is not authorized' do
      before { get :index }

      it 'redirects to the root path' do
        expect(response).to redirect_to(new_session_path)
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq('Please sign in')
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:bid) { create(:bid) }

    before do
      session[:user_id] = user.id
    end

    context 'when bid exists' do
      before { get :show, params: { id: bid.id } }

      it 'returns a successful response' do
        expect(response).to be_successful
      end
    end

    context 'when bid does not exist' do
      before { get :show, params: { id: 999 } }

      it 'redirects to the bids path' do
        expect(response).to redirect_to(bids_path)
      end
    end
  end

  describe 'GET #new' do
    context 'when user is a freelancer' do
      let(:category) { create(:category) }
      let(:freelancer) { create(:user, role: 'freelancer', categories: [category]) }
      let(:project) { create(:project) }

      before do
        session[:user_id] = freelancer.id
        get :new, params: { project_id: project.id }
      end

      it 'renders the new template' do
        expect(response).to be_successful
      end
    end

    context 'when user is not a freelancer' do
      let(:user) { create(:user) }
      let(:project) { create(:project) }

      before do
        session[:user_id] = user.id
        get :new, params: { project_id: project.id }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('Bid cannot be created')
      end
    end
  end

  describe 'POST #create' do
    context 'when bid is valid' do
      let(:category) { create(:category) }
      let(:freelancer) { create(:user, role: 'freelancer', categories: [category]) }
      let(:project) { create(:project) }
      let(:user) { create(:user) }
      let(:valid_bid_params) { attributes_for(:bid, project_id: project.id, user_id: user.id) }

      before do
        session[:user_id] = freelancer.id
      end

      it 'creates a new bid' do
        expect do
          post :create, params: { bid: valid_bid_params }
        end.to change(Bid, :count).by(1)
      end

      it 'redirects to the project' do
        post :create, params: { bid: valid_bid_params }
        expect(response).to redirect_to(project)
      end

      it 'sets the flash success message' do
        post :create, params: { bid: valid_bid_params }
        expect(flash[:success]).to eq('Bid was successfully created')
      end
    end

    context 'when bid is invalid' do
      let(:category) { create(:category) }
      let(:freelancer) { create(:user, role: 'freelancer', categories: [category]) }
      let(:project) { create(:project) }
      let(:invalid_bid_params) do
        attributes_for(:bid, project_id: project.id, user_id: freelancer.id, bid_amount: -100)
      end

      before do
        session[:user_id] = freelancer.id
      end

      it 'does not create a new bid' do
        expect do
          post :create, params: { bid: invalid_bid_params }
        end.not_to change(Bid, :count)
      end

      it 'sets the flash error message' do
        post :create, params: { bid: invalid_bid_params }
        expect(flash[:error]).to eq('Bid could not be created.')
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is authenticated and bid is modifiable' do
      let(:user) { create(:user) }
      let(:bid) { create(:bid, user:, bid_status: 'pending') }

      before do
        session[:user_id] = user.id
        get :edit, params: { id: bid.id }
      end

      it 'renders the edit template' do
        expect(response).to be_successful
      end
    end

    context 'when user is not authenticated' do
      let(:bid) { create(:bid) }

      before do
        get :edit, params: { id: bid.id }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(new_session_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('Please sign in')
      end
    end

    context 'when bid is not modifiable' do
      let(:user) { create(:user) }
      let(:project) { create(:project, user_id: user.id) }
      let(:category) { create(:category) }
      let(:freelancer) { create(:user, role: 'freelancer', categories: [category]) }
      let(:bid) { create(:bid, project:, user: freelancer, bid_status: 'accepted') }

      before do
        session[:user_id] = user.id
        get :edit, params: { id: bid.id }
      end

      it 'redirects to the bids path' do
        expect(response).to redirect_to(bids_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('Bid cannot be modified')
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is authenticated, bid is modifiable, and update is successful' do
      let(:user) { create(:user) }
      let(:bid) { create(:bid, user:, bid_status: 'pending') }
      let(:valid_update_params) { { bid_description: 'Updated description' } }

      before do
        session[:user_id] = user.id
        patch :update, params: { id: bid.id, bid: valid_update_params }
      end

      it 'updates the bid' do
        bid.reload
        expect(bid.bid_description).to eq('Updated description')
      end

      it 'redirects to the bid' do
        expect(response).to redirect_to(bid)
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to eq('Bid was successfully updated')
      end
    end

    context 'when user is not authenticated' do
      let(:bid) { create(:bid) }
      let(:valid_update_params) { { bid_description: 'Updated description' } }

      before do
        patch :update, params: { id: bid.id, bid: valid_update_params }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(new_session_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('Please sign in')
      end
    end

    context 'when bid is not modifiable' do
      let(:user) { create(:user) }
      let(:bid) { create(:bid, user:, bid_status: 'accepted') }
      let(:valid_update_params) { { bid_description: 'Updated description' } }

      before do
        session[:user_id] = user.id
        patch :update, params: { id: bid.id, bid: valid_update_params }
      end

      it 'redirects to the bids path' do
        expect(response).to redirect_to(bid)
      end
    end

    context 'when update is unsuccessful' do
      let(:user) { create(:user) }
      let(:bid) { create(:bid, user:, bid_status: 'pending') }
      let(:invalid_update_params) { { bid_amount: -100 } }

      before do
        session[:user_id] = user.id
        patch :update, params: { id: bid.id, bid: invalid_update_params }
      end

      it 'does not update the bid' do
        bid.reload
        expect(bid.bid_amount).not_to eq(-100)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('Please enter the information correctly')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:project) { create(:project, user_id: user.id) }
    let(:category) { create(:category) }
    let(:freelancer) { create(:user, role: 'freelancer', categories: [category]) }
    let(:bid) { create(:bid, project:, user: freelancer, bid_status: 'accepted') }

    it 'destroys the bid and redirects to the bids index page' do
      session[:user_id] = user.id
      delete :destroy, params: { id: bid.id }

      expect(response).to redirect_to(bids_path)
    end
  end

  describe 'POST #accept' do
    context 'when user is authenticated and is the project owner' do
      let(:user) { create(:user) }
      let(:project) { create(:project, user:) }
      let(:bid) { create(:bid, project:, bid_status: 'pending') }

      before do
        session[:user_id] = user.id
        post :accept, params: { id: bid.id }
      end

      it 'updates the bid status to accepted' do
        bid.reload
        expect(bid).to be_accepted
      end

      it 'updates the project to have an awarded bid' do
        project.reload
        expect(project).to have_awarded_bid
      end

      it 'redirects to the project page' do
        expect(response).to redirect_to(project)
      end

      it 'sets a flash notice' do
        expect(flash[:notice]).to eq('Bid accepted')
      end
    end

    context 'when user is not authenticated' do
      let(:bid) { create(:bid, bid_status: 'pending') }

      before do
        post :accept, params: { id: bid.id }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(new_session_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('Please sign in')
      end
    end

    context 'when user is authenticated but is not the project owner' do
      let(:user) { create(:user) }
      let(:project) { create(:project, user:) }
      let(:bid) { create(:bid, project:, bid_status: 'pending') }

      before do
        session[:user_id] = user.id
        post :accept, params: { id: bid.id }
      end

      it 'redirects to the project page' do
        expect(response).to redirect_to(project_path(bid.project))
      end
    end
  end

  describe 'POST #reject' do
    context 'when user is authenticated and is the project owner' do
      let(:user) { create(:user) }
      let(:project) { create(:project, user:) }
      let(:bid) { create(:bid, project:, bid_status: 'pending') }

      before do
        session[:user_id] = user.id
        post :reject, params: { id: bid.id }
      end

      it 'updates the bid status to rejected' do
        bid.reload
        expect(bid).to be_rejected
      end

      it 'redirects to the project page' do
        expect(response).to redirect_to(project)
      end

      it 'sets a flash notice' do
        expect(flash[:notice]).to eq('Bid rejected')
      end
    end

    context 'when user is not authenticated' do
      let(:bid) { create(:bid, bid_status: 'pending') }

      before do
        post :reject, params: { id: bid.id }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(new_session_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('Please sign in')
      end
    end

    context 'when user is authenticated but is not the project owner' do
      let(:user) { create(:user) }
      let(:bid) { create(:bid, bid_status: 'pending') }

      before do
        session[:user_id] = user.id
        post :reject, params: { id: bid.id }
      end

      it 'redirects to the project page' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('You are not authorized to perform this action')
      end
    end
  end
end
