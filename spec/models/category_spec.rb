# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category do
  let(:category) { build(:category) }

  describe 'validations' do
    context 'when name is present and unique' do
      it 'is valid' do
        expect(category).to be_valid
      end
    end

    context 'when name is not present' do
      it 'is not valid' do
        category.name = nil
        expect(category).not_to be_valid
      end
    end

    context 'when name is not unique' do
      it 'is not valid' do
        create(:category, name: 'Test')
        category.name = 'Test'
        expect(category).not_to be_valid
      end
    end
  end

  describe 'associations' do
    context 'when associated with projects and users' do
      let!(:project) { create(:project) }
      let!(:user) { create(:user) }

      before do
        category.projects << project
        category.users << user
      end

      it 'has the correct projects' do
        expect(category.projects).to include(project)
      end

      it 'has the correct users' do
        expect(category.users).to include(user)
      end
    end

    context 'when not associated with any projects or users' do
      it 'has no projects' do
        expect(category.projects).to be_empty
      end

      it 'has no users' do
        expect(category.users).to be_empty
      end
    end
  end
end
