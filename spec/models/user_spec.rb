# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it 'validates presence of email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'validates length of email' do
      user = build(:user, email: 'a' * 256)
      expect(user).not_to be_valid
    end

    it 'validates format of email' do
      user = build(:user, email: 'invalid_email')
      expect(user).not_to be_valid
    end

    it 'validates uniqueness of email' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
    end

    it 'validates presence of password on create' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it 'validates length of password on create' do
      user = build(:user, password: '12345')
      expect(user).not_to be_valid
    end

    it 'validates presence of username' do
      user = build(:user, username: nil)
      expect(user).not_to be_valid
    end

    it 'validates uniqueness of username' do
      create(:user, username: 'testuser')
      user = build(:user, username: 'testuser')
      expect(user).not_to be_valid
    end

    it 'validates length of username' do
      user = build(:user, username: 'a' * 256)
      expect(user).not_to be_valid
    end

    it 'validates numericality of experience' do
      user = build(:user, experience: 'non-numeric')
      expect(user).not_to be_valid
    end

    it 'validates number of years of experience' do
      user = build(:user, experience: 101)
      expect(user).not_to be_valid
    end

    it 'validates presence of role' do
      user = build(:user, role: nil)
      expect(user).not_to be_valid
    end

    it 'validates inclusion of role' do
      expect { build(:user, role: 'invalid_role') }.to raise_error(ArgumentError, /is not a valid role/)
    end
  end

  it 'has a valid factory' do
    user = build(:user)
    expect(user).to be_valid
  end
end
