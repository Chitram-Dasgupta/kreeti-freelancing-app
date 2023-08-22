# frozen_string_literal: true

RSpec.describe NotificationsController do
  let(:user) { create(:user) }
  let(:project) { create(:project, user:) }
  let(:bid) { create(:bid, user:, project:) }

  before { session[:user_id] = user.id }

  describe 'GET #count' do
    it 'returns the notification count' do
      create_list(:notification, 3, recipient: user)
      get :count
      expect(response).to have_http_status(:success)
      response_data = response.parsed_body
      expect(response_data['unread_count']).to eq(3)
      expect(response_data['full_count']).to eq(3)
    end
  end

  describe 'DELETE #delete_read' do
    it 'deletes read notifications' do
      create(:notification, recipient: user, read: true)
      create(:notification, recipient: user, read: false)
      expect do
        delete :delete_read
      end.to change(Notification, :count).by(-1)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #fetch_notifications' do
    it 'fetches notifications' do
      notifications = create_list(:notification, 5, recipient: user)
      get :fetch_notifications
      expect(response).to have_http_status(:success)
      response_data = response.parsed_body
      expect(response_data.length).to eq(5)
      expect(response_data.first['message']).to eq(notifications.first.message)
    end
  end

  describe 'PATCH #mark_all_as_read' do
    it 'marks all notifications as read' do
      create_list(:notification, 5, recipient: user, read: false)
      patch :mark_all_as_read
      expect(response).to have_http_status(:success)
      expect(user.notifications.where(read: false).count).to eq(0)
    end
  end

  describe 'PATCH #mark_as_read' do
    it 'marks a notification as read' do
      notification = create(:notification, recipient: user, read: false)
      patch :mark_as_read, params: { id: notification.id }
      expect(response).to have_http_status(:success)
      expect(notification.reload.read).to be(true)
    end
  end
end
