# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserCategory do
  describe 'associations' do
    it 'belongs to user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to category' do
      association = described_class.reflect_on_association(:category)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    let(:user_cat) { create(:user_category) }

    it 'is valid with valid attributes' do
      expect(user_cat).to be_valid
    end

    it 'is not valid without a user' do
      user_cat.user = nil
      expect(user_cat).not_to be_valid
    end

    it 'is not valid without a category' do
      user_cat.category = nil
      expect(user_cat).not_to be_valid
    end
  end
end
