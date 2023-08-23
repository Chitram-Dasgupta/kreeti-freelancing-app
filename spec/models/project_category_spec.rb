# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectCategory do
  describe 'associations' do
    it 'belongs to project' do
      association = described_class.reflect_on_association(:project)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to category' do
      association = described_class.reflect_on_association(:category)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    let(:project_cat) { create(:project_category) }

    it 'is valid with valid attributes' do
      expect(project_cat).to be_valid
    end

    it 'is not valid without a project' do
      project_cat.project = nil
      expect(project_cat).not_to be_valid
    end

    it 'is not valid without a category' do
      project_cat.category = nil
      expect(project_cat).not_to be_valid
    end
  end
end
