# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bid do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:bid) { build(:bid, user:, project:) }

  it 'is valid with valid attributes' do
    expect(bid).to be_valid
  end

  it 'is not valid without a bid_amount' do
    bid.bid_amount = nil
    expect(bid).not_to be_valid
  end

  it 'is not valid with a bid_amount less than or equal to 0' do
    bid.bid_amount = 0
    expect(bid).not_to be_valid
  end

  it 'is not valid with a bid_amount greater than 1_000_000' do
    bid.bid_amount = 1_000_001
    expect(bid).not_to be_valid
  end

  it 'is not valid without a user_id' do
    bid.user_id = nil
    expect(bid).not_to be_valid
  end

  it 'is not valid without a project_id' do
    bid.project_id = nil
    expect(bid).not_to be_valid
  end
end
