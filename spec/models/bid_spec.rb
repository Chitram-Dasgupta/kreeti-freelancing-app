# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bid do
  let(:project) { create(:project) }
  let(:user) { create(:user) }
  let(:bid) { build(:bid, project:, user:) }
  let(:other_bid) { build(:bid, project:) }

  describe 'validations' do
    context 'when all attributes are valid' do
      it 'is valid' do
        expect(bid).to be_valid
      end
    end

    context 'when bid_amount is not present' do
      it 'is not valid' do
        bid.bid_amount = nil
        expect(bid).not_to be_valid
      end
    end

    context 'when bid_amount is not a number' do
      it 'is not valid' do
        bid.bid_amount = 'abc'
        expect(bid).not_to be_valid
      end
    end

    context 'when bid_amount is less than or equal to 0' do
      it 'is not valid' do
        bid.bid_amount = 0
        expect(bid).not_to be_valid
      end
    end

    context 'when bid_amount is greater than or equal to 1_000_000' do
      it 'is not valid' do
        bid.bid_amount = 1_000_000
        expect(bid).not_to be_valid
      end
    end

    context 'when user_id is not unique within the scope of project_id' do
      it 'is not valid' do
        create(:bid, user: bid.user, project: bid.project)
        expect(bid).not_to be_valid
      end
    end

    context 'when bid_description is longer than 1024 characters' do
      it 'is not valid' do
        bid.bid_description = 'a' * 1025
        expect(bid).not_to be_valid
      end
    end
  end

  describe 'associations' do
    context 'when all associations are present' do
      it 'is valid' do
        expect(bid).to be_valid
      end
    end

    context 'when project is not present' do
      it 'is not valid' do
        bid.project = nil
        expect(bid).not_to be_valid
      end
    end

    context 'when user is not present' do
      it 'is not valid' do
        bid.user = nil
        expect(bid).not_to be_valid
      end
    end

    context 'when notifications are associated' do
      it 'deletes the notifications when the bid is deleted' do
        create(:notification, bid:)
        expect { bid.destroy }.to change(Notification, :count).by(-1)
      end
    end

    context 'when notifications are not associated' do
      it 'does not delete any notifications when the bid is deleted' do
        expect { bid.destroy }.not_to change(Notification, :count)
      end
    end
  end

  describe '#accept' do
    context 'when the bid is pending' do
      before do
        bid.accept
      end

      it 'updates the bid status to accepted' do
        expect(bid.accepted?).to be true
      end
    end

    context 'when the bid is already accepted' do
      before do
        bid.accept
        bid.accept
      end

      it 'does not change the bid status' do
        expect(bid.accepted?).to be true
      end
    end

    context 'when the bid is rejected' do
      before do
        bid.reject
        bid.accept
      end

      it 'does not change the bid status' do
        expect(bid.rejected?).to be true
      end
    end
  end

  describe '#reject' do
    context 'when the bid is pending' do
      before do
        bid.reject
      end

      it 'updates the bid status to rejected' do
        expect(bid.rejected?).to be true
      end
    end

    context 'when the bid is already rejected' do
      before do
        bid.reject
        bid.reject
      end

      it 'does not change the bid status' do
        expect(bid.rejected?).to be true
      end
    end

    context 'when the bid is accepted' do
      before do
        bid.accept
        bid.reject
      end

      it 'does not change the bid status' do
        expect(bid.accepted?).to be true
      end
    end
  end

  describe '#modifiable?' do
    context 'when the bid is pending' do
      it 'returns true' do
        expect(bid.modifiable?).to be true
      end
    end

    context 'when the bid is accepted' do
      before do
        bid.accept
      end

      it 'returns false' do
        expect(bid.modifiable?).to be false
      end
    end

    context 'when the bid is rejected' do
      before do
        bid.reject
      end

      it 'returns false' do
        expect(bid.modifiable?).to be false
      end
    end
  end

  describe '#upload_project_files' do
    before do
      bid.upload_project_files
    end

    it 'updates project_files_uploaded to true' do
      expect(bid.project_files_uploaded).to be true
    end
  end

  describe '#send_notifications' do
    context 'when bid status changes' do
      it 'creates a notification for the bid' do
        expect do
          bid.accept
        end.to change(Notification, :count).by(1)
      end
    end

    context 'when project files are uploaded' do
      it 'creates a notification for the project files upload' do
        expect do
          bid.upload_project_files
        end.to change(Notification, :count).by(1)
      end
    end
  end

  describe '#update_project' do
    context 'when bid is accepted' do
      before do
        bid.accept
      end

      it 'updates the project has_awarded_bid to true' do
        expect(project.reload.has_awarded_bid).to be true
      end
    end

    context 'when bid is pending or rejected' do
      it 'does not update the project has_awarded_bid' do
        expect(project.reload.has_awarded_bid).to be false
      end
    end
  end
end
