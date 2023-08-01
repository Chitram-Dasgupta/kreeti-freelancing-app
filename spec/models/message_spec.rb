# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message do
  let(:message) { build(:message) }

  describe 'validations' do
    context 'when content is present and within length limit' do
      it 'is valid' do
        expect(message).to be_valid
      end
    end

    context 'when content is not present' do
      it 'is not valid' do
        message.content = nil
        expect(message).not_to be_valid
      end
    end

    context 'when content is too long' do
      it 'is not valid' do
        message.content = 'a' * 256
        expect(message).not_to be_valid
      end
    end
  end

  describe 'associations' do
    context 'when associated with a room and a user' do
      let(:room) { create(:room) }
      let(:user) { create(:user) }

      it 'belongs to the correct room' do
        message.room = room
        expect(message.room).to eq(room)
      end

      it 'belongs to the correct user' do
        message.user = user
        expect(message.user).to eq(user)
      end
    end

    context 'when not associated with a room or a user' do
      it 'is not valid without a room' do
        message.room = nil
        expect(message).not_to be_valid
      end

      it 'is not valid without a user' do
        message.user = nil
        expect(message).not_to be_valid
      end
    end
  end
end
