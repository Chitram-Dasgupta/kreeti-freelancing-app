# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagesController do
  let(:current_user) { create(:user) }
  let(:category) { create(:category) }
  let(:other_user) { create(:user, :freelancer, categories: [category]) }
  let(:room) { create(:room) }

  describe 'POST #create' do
    before { session[:user_id] = current_user.id }

    context 'with valid parameters' do
      let(:valid_params) { { room_id: room.id, message: { content: 'Hello' } } }

      it 'creates a new message' do
        expect { post :create, params: valid_params, format: :json }.to change(Message, :count).by(1)
      end

      it 'broadcasts the created message' do
        post :create, params: valid_params, format: :json
        expect(response.parsed_body['status']).to eq 'ok'
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { room_id: room.id, message: { content: '' } } }

      it 'does not create a new message' do
        expect { post :create, params: invalid_params, format: :json }.not_to change(Message, :count)
      end

      it 'returns error response' do
        post :create, params: invalid_params, format: :json
        expect(response.parsed_body['status']).to eq 'error'
      end
    end
  end
end
