# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room do
  describe 'associations' do
    it 'has many messages' do
      room = create(:room)
      message1 = create(:message, room:)
      message2 = create(:message, room:)

      expect(room.messages).to include(message1, message2)
    end

    it 'has many user_rooms' do
      room = create(:room)
      user1 = create(:user)
      user2 = create(:user, :freelancer)
      user_room1 = create(:user_room, room:, user1:, user2:)
      user_room2 = create(:user_room, room:, user1:, user2:)

      expect(room.user_rooms).to include(user_room1, user_room2)
    end

    it 'has many users through user_rooms' do
      room = create(:room)
      user1 = create(:user)
      user2 = create(:user)
      create(:user_room, room:, user1:, user2:)
      create(:user_room, room:, user1:, user2:)

      users = room.user_rooms.map { |ur| [ur.user1, ur.user2] }.flatten
      expect(users).to include(user1, user2)
    end
  end

  describe 'dependent destroy' do
    let(:room) { create(:room) }
    let(:first_user) { create(:user) }
    let(:second_user) { create(:user, :freelancer) }
    let!(:message) { create(:message, room:) }
    let!(:user_room) { create(:user_room, room:, user1: first_user, user2: second_user) }

    it 'destroys associated messages when destroyed' do
      expect { room.destroy }.to change(Message, :count).by(-1)
    end

    it 'destroys associated user_rooms when destroyed' do
      expect { room.destroy }.to change(UserRoom, :count).by(-1)
    end
  end
end
