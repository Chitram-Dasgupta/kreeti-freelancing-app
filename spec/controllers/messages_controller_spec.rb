# frozen_string_literal: true

RSpec.describe MessagesController do
  let(:current_user) { create(:user) }
  let(:category) { create(:category) }
  let(:other_user) { create(:user, :freelancer, categories: [category]) }
  let(:room) { create(:room) }

  describe 'POST #create' do
    before { session[:user_id] = current_user.id }

    context 'with valid parameters' do
      let(:valid_params) { { room_id: room.id, message: { content: 'Hello' } } }

      it 'creates a new message and broadcasts it' do
        expect { post :create, params: valid_params, format: :json }.to change(Message, :count).by(1)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'application/json; charset=utf-8'

        parsed_response = response.parsed_body
        expect(parsed_response['status']).to eq 'ok'
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { room_id: room.id, message: { content: '' } } }

      it 'does not create a new message and returns error' do
        expect do
          post :create, params: invalid_params, format: :json
        end.not_to change(Message, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq 'application/json; charset=utf-8'

        parsed_response = response.parsed_body
        expect(parsed_response['status']).to eq 'error'
        expect(parsed_response['errors']).to be_present
      end
    end
  end
end
