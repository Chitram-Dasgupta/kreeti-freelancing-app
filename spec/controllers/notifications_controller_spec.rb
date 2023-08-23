# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsController do
  let(:user) { create(:user) }
  let(:project) { create(:project, user:) }
  let(:bid) { create(:bid, user:, project:) }

  before { session[:user_id] = user.id }

  describe 'GET #count' do
    before do
      create_list(:notification, 3, recipient: user)
      get :count
    end

    it 'returns the count of unread notifications' do
      expect(response.parsed_body['unread_count']).to eq(3)
    end

    it 'returns the count of all notifications' do
      expect(response.parsed_body['full_count']).to eq(3)
    end
  end

  describe 'DELETE #delete_read' do
    before do
      create(:notification, recipient: user, read: true)
      create(:notification, recipient: user, read: false)
    end

    it 'deletes read notifications' do
      expect { delete :delete_read }.to change(Notification, :count).by(-1)
    end
  end

  describe 'GET #fetch_notifications' do
    before do
      create_list(:notification, 5, recipient: user)
      get :fetch_notifications
    end

    it 'fetches notification count' do
      expect(response.parsed_body.length).to eq(5)
    end

    it 'fetches the notifications' do
      expect(response.parsed_body.last['message']).to eq(Notification.last.message)
    end
  end

  describe 'PATCH #mark_all_as_read' do
    it 'marks all notifications as read' do
      create_list(:notification, 5, recipient: user, read: false)
      patch :mark_all_as_read
      expect(user.notifications.where(read: false).count).to eq(0)
    end
  end

  describe 'PATCH #mark_as_read' do
    it 'marks a notification as read' do
      notification = create(:notification, recipient: user, read: false)
      patch :mark_as_read, params: { id: notification.id }
      expect(notification.reload.read).to be(true)
    end
  end
end
