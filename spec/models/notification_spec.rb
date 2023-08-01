# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification do
  let(:user) { create(:user) }
  let(:project) { create(:project, user:) }
  let(:bid) { create(:bid, user:, project:) }
  let(:notification) { build(:notification, recipient: user, project:, bid:) }

  describe 'validations' do
    context 'when all attributes are valid' do
      it 'is valid' do
        expect(notification).to be_valid
      end
    end

    context 'when message is not present' do
      it 'is not valid' do
        notification.message = nil
        expect(notification).not_to be_valid
      end
    end

    context 'when message is too long' do
      it 'is not valid' do
        notification.message = 'a' * 256
        expect(notification).not_to be_valid
      end
    end
  end

  describe 'associations' do
    context 'when associated with a recipient, a project, and a bid' do
      it 'belongs to the correct recipient' do
        expect(notification.recipient).to eq(user)
      end

      it 'belongs to the correct project' do
        expect(notification.project).to eq(project)
      end

      it 'belongs to the correct bid' do
        expect(notification.bid).to eq(bid)
      end
    end

    context 'when not associated with a recipient, a project, or a bid' do
      it 'is not valid without a recipient' do
        notification.recipient = nil
        expect(notification).not_to be_valid
      end

      it 'is not valid without a project' do
        notification.project = nil
        expect(notification).not_to be_valid
      end

      it 'is not valid without a bid' do
        notification.bid = nil
        expect(notification).not_to be_valid
      end
    end
  end

  describe '.create_for_bid' do
    context 'when bid exists' do
      it 'creates a notification' do
        expect { described_class.create_for_bid(bid) }.to change(described_class, :count).by(1)
      end
    end

    context 'when bid does not exist' do
      it 'does not create a notification' do
        expect { described_class.create_for_bid(nil) }.to raise_error(NoMethodError)
      end
    end
  end

  describe '.create_for_project_files_upload' do
    context 'when bid exists' do
      it 'creates a notification' do
        expect { described_class.create_for_project_files_upload(bid) }.to change(described_class, :count).by(1)
      end
    end

    context 'when bid does not exist' do
      it 'does not create a notification' do
        expect { described_class.create_for_project_files_upload(nil) }.to raise_error(NoMethodError)
      end
    end
  end
end
