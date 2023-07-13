# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification do
  describe 'validations' do
    it 'validates presence of message' do
      notification = build(:notification, message: nil)
      expect(notification).not_to be_valid
    end

    it 'validates length of message' do
      notification = build(:notification, message: 'a' * 256)
      expect(notification).not_to be_valid
    end
  end
end
