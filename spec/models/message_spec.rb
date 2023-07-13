# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message do
  describe 'validations' do
    it 'validates presence of content' do
      message = build(:message, content: nil)
      expect(message).not_to be_valid
    end

    it 'validates length of content' do
      message = build(:message, content: 'a' * 256)
      expect(message).not_to be_valid
    end
  end
end
