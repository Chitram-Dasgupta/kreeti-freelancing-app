# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:user) { build(:user) }

  describe 'validations' do
    context 'when password is correct' do
      it 'authenticates the user' do
        expect(user.authenticate('password')).to be_truthy
      end
    end

    context 'when password is incorrect' do
      it 'does not authenticate the user' do
        expect(user.authenticate('wrong_password')).to be_falsey
      end
    end

    context 'when email is present' do
      it 'is valid' do
        user.email = 'user@example.com'
        expect(user.valid?).to be_truthy
      end
    end

    context 'when email is not present' do
      it 'is not valid' do
        user.email = nil
        expect(user.valid?).to be_falsey
      end
    end

    context 'when email format is correct' do
      it 'is valid' do
        user.email = 'user@example.com'
        expect(user.valid?).to be_truthy
      end
    end

    context 'when email format is incorrect' do
      it 'is not valid' do
        user.email = 'user'
        expect(user.valid?).to be_falsey
      end
    end

    context 'when password is present on create' do
      it 'is valid' do
        user.password = 'password'
        expect(user.valid?).to be_truthy
      end
    end

    context 'when password is not present on create' do
      it 'is not valid' do
        user.password = nil
        expect(user.valid?).to be_falsey
      end
    end

    context 'when password length is at least 6 on create' do
      it 'is valid' do
        user.password = 'password'
        expect(user.valid?).to be_truthy
      end
    end

    context 'when password length is less than 6 on create' do
      it 'is not valid' do
        user.password = 'pass'
        expect(user.valid?).to be_falsey
      end
    end

    context 'when role is present' do
      it 'is valid' do
        user.role = :client
        expect(user.valid?).to be_truthy
      end
    end

    context 'when role is not present' do
      it 'is not valid' do
        user.role = nil
        expect(user.valid?).to be_falsey
      end
    end

    context 'when role is one of the defined enum values' do
      it 'is valid' do
        user.role = :client
        expect(user.valid?).to be_truthy
      end
    end

    context 'when role is not one of the defined enum values' do
      it 'is not valid' do
        expect { build(:user, role: 'invalid_role') }.to raise_error(ArgumentError, /is not a valid role/)
      end
    end

    context 'when username is present' do
      it 'is valid' do
        user.username = 'username'
        expect(user.valid?).to be_truthy
      end
    end

    context 'when username is not present' do
      it 'is not valid' do
        user.username = nil
        expect(user.valid?).to be_falsey
      end
    end

    context 'when username is unique' do
      it 'is valid' do
        user.username = 'unique_username'
        expect(user.valid?).to be_truthy
      end
    end

    context 'when username is not unique' do
      it 'is not valid' do
        User.create!(username: 'username', email: 'user2@example.com', password: 'password')
        user.username = 'username'
        expect(user.valid?).to be_falsey
      end
    end

    context 'when user is a freelancer and categories are present' do
      it 'is valid' do
        user.role = :freelancer
        user.categories = [build(:category)]
        expect(user.valid?).to be_truthy
      end
    end

    context 'when user is a freelancer and categories are not present' do
      it 'is not valid' do
        user.role = :freelancer
        user.categories = []
        expect(user.valid?).to be_falsey
      end
    end
  end

  describe 'associations' do
    it 'can have many bids' do
      user.bids << create(:bid)
      user.save
      expect(user.bids.count).to eq(1)
    end

    it 'can have many projects' do
      user.projects << create(:project)
      user.save
      expect(user.projects.count).to eq(1)
    end

    it 'can have many messages' do
      user.messages << create(:message)
      user.save
      expect(user.messages.count).to eq(1)
    end

    it 'can have many notifications' do
      user.notifications << create(:notification)
      user.save
      expect(user.notifications.count).to eq(1)
    end

    it 'can have many user1_rooms' do
      user.user1_rooms << create(:user_room, user1: user)
      user.save
      expect(user.user1_rooms.count).to eq(1)
    end

    it 'can have many user2_rooms' do
      user.user2_rooms << create(:user_room, user2: user)
      user.save
      expect(user.user2_rooms.count).to eq(1)
    end

    it 'can have many rooms as user1' do
      create(:user_room, user1: user)
      user.save
      expect(user.user1_rooms.count).to eq(1)
    end

    it 'can have many rooms as user2' do
      create(:user_room, user2: user)
      user.save
      expect(user.user2_rooms.count).to eq(1)
    end

    it 'can have many categories through user_categories' do
      user.user_categories << build(:user_category)
      user.save
      expect(user.categories.count).to eq(1)
    end
  end
end
