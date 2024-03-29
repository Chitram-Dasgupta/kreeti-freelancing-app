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

    context 'when email is present and format is correct' do
      it 'is valid' do
        user.email = 'user@example.com'
        expect(user).to be_valid
      end
    end

    context 'when email is not present' do
      it 'is not valid' do
        user.email = nil
        expect(user).not_to be_valid
      end
    end

    context 'when email format is incorrect' do
      it 'is not valid' do
        user.email = 'user'
        expect(user).not_to be_valid
      end
    end

    context 'when password is present and at least 6 characters long on create' do
      it 'is valid' do
        user.password = 'password'
        expect(user).to be_valid
      end
    end

    context 'when password is not present on create' do
      it 'is not valid' do
        user.password = nil
        expect(user).not_to be_valid
      end
    end

    context 'when password length is less than 6 on create' do
      it 'is not valid' do
        user.password = 'pass'
        expect(user).not_to be_valid
      end
    end

    context 'when role is present and one of the defined enum values' do
      it 'is valid' do
        user.role = :client
        expect(user).to be_valid
      end
    end

    context 'when role is not present' do
      it 'is not valid' do
        user.role = nil
        expect(user).not_to be_valid
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
        expect(user).to be_valid
      end
    end

    context 'when username is not present' do
      it 'is not valid' do
        user.username = nil
        expect(user).not_to be_valid
      end
    end

    context 'when username is unique' do
      it 'is valid' do
        user.username = 'unique_username'
        expect(user).to be_valid
      end
    end

    context 'when username is not unique' do
      it 'is not valid' do
        described_class.create!(username: 'username', email: 'receiver@example.com', password: 'password')
        user.username = 'username'
        expect(user).not_to be_valid
      end
    end

    context 'when user is a freelancer and categories are present' do
      it 'is valid' do
        user.role = :freelancer
        user.categories = [build(:category)]
        expect(user).to be_valid
      end
    end

    context 'when user is a freelancer and categories are not present' do
      it 'is not valid' do
        user.role = :freelancer
        user.categories = []
        expect(user).not_to be_valid
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

    it 'can have many sender_rooms' do
      user.sender_rooms << create(:user_room, sender: user)
      user.save
      expect(user.sender_rooms.count).to eq(1)
    end

    it 'can have many receiver_rooms' do
      user.receiver_rooms << create(:user_room, receiver: user)
      user.save
      expect(user.receiver_rooms.count).to eq(1)
    end

    it 'can have many rooms as sender' do
      create(:user_room, sender: user)
      user.save
      expect(user.sender_rooms.count).to eq(1)
    end

    it 'can have many rooms as receiver' do
      create(:user_room, receiver: user)
      user.save
      expect(user.receiver_rooms.count).to eq(1)
    end

    it 'can have many categories through user_categories' do
      user.user_categories << build(:user_category)
      user.save
      expect(user.categories.count).to eq(1)
    end
  end
end
