# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserRoom do
  describe 'associations' do
    it 'belongs to room' do
      association = described_class.reflect_on_association(:room)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to sender' do
      association = described_class.reflect_on_association(:sender)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to receiver' do
      association = described_class.reflect_on_association(:receiver)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'scopes' do
    describe '.belongs_to_user' do
      let(:first_user) { create(:user) }
      let(:second_user) { create(:user) }
      let(:third_user) { create(:user) }
      let(:first_user_room) { create(:user_room, sender: first_user, receiver: second_user) }
      let(:second_user_room) { create(:user_room, sender: second_user, receiver: third_user) }

      it 'returns user rooms that belong to the specified user' do
        expect(described_class.belongs_to_user(second_user)).to eq([first_user_room, second_user_room])
      end
    end
  end

  describe '#other_user' do
    let(:first_user) { create(:user) }
    let(:second_user) { create(:user) }
    let(:user_room) { create(:user_room, sender: first_user, receiver: second_user) }

    it 'returns the other user in the user room' do
      expect(user_room.other_user(first_user)).to eq(second_user)
    end
  end
end
