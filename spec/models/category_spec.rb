# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category do
  describe 'validations' do
    it 'validates presence of name' do
      category = build(:category, name: nil)
      expect(category).not_to be_valid
    end
  end
end
