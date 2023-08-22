# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room do
  describe 'associations' do
    let(:room) { create(:room) }
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it 'has many messages' do
      message1 = create(:message, room:)
      message2 = create(:message, room:)

      expect(room.messages).to include(message1, message2)
    end

    it 'has many user_rooms' do
      user_room1 = create(:user_room, room:, user1: user, user2: other_user)
      user_room2 = create(:user_room, room:, user1: user, user2: other_user)

      expect(room.user_rooms).to include(user_room1, user_room2)
    end

    it 'has many users through user_rooms' do
      create(:user_room, room:, user1: user, user2: other_user)
      create(:user_room, room:, user1: user, user2: other_user)

      users = room.user_rooms.map { |ur| [ur.user1, ur.user2] }.flatten
      expect(users).to include(user, other_user)
    end
  end

  describe 'dependent destroy' do
    let(:room) { create(:room) }
    let(:first_user) { create(:user) }
    let(:second_user) { create(:user, :freelancer) }

    it 'destroys associated messages when destroyed' do
      create(:message, room:)
      expect { room.destroy }.to change(Message, :count).by(-1)
    end

    it 'destroys associated user_rooms when destroyed' do
      create(:user_room, room:, user1: first_user, user2: second_user)
      expect { room.destroy }.to change(UserRoom, :count).by(-1)
    end
  end
end
