# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:project) { build(:project, user:, categories: [category]) }

  describe 'validations' do
    context 'when all attributes are valid' do
      it 'is valid' do
        expect(project).to be_valid
      end
    end

    context 'when title is not present' do
      it 'is not valid' do
        project.title = nil
        expect(project).not_to be_valid
      end
    end

    context 'when title is too long' do
      it 'is not valid' do
        project.title = 'a' * 65
        expect(project).not_to be_valid
      end
    end

    context 'when description is too long' do
      it 'is not valid' do
        project.description = 'a' * 1025
        expect(project).not_to be_valid
      end
    end

    context 'when categories are not present' do
      it 'is not valid' do
        project.categories = []
        expect(project).not_to be_valid
      end
    end
  end

  describe 'associations' do
    context 'when associated with a user and categories' do
      it 'belongs to the correct user' do
        expect(project.user).to eq(user)
      end

      it 'has the correct categories' do
        expect(project.categories).to include(category)
      end
    end

    context 'when not associated with a user or categories' do
      it 'is not valid without a user' do
        project.user = nil
        expect(project).not_to be_valid
      end

      it 'is not valid without categories' do
        project.categories = []
        expect(project).not_to be_valid
      end
    end
  end

  describe '#bid_awarded?' do
    context 'when a bid has been awarded' do
      before do
        create(:bid, project:, bid_status: 'accepted')
      end

      it 'returns true' do
        expect(project.bid_awarded?).to be true
      end
    end

    context 'when no bid has been awarded' do
      it 'returns false' do
        expect(project.bid_awarded?).to be false
      end
    end
  end

  describe '#accepted_bid_freelancer' do
    context 'when a bid has been accepted' do
      let(:freelancer) { create(:user) }

      before do
        create(:bid, project:, user: freelancer, bid_status: 'accepted')
      end

      it 'returns the freelancer of the accepted bid' do
        expect(project.accepted_bid_freelancer).to eq(freelancer)
      end
    end

    context 'when no bid has been accepted' do
      it 'returns nil' do
        expect(project.accepted_bid_freelancer).to be_nil
      end
    end
  end
end
