# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project do
  describe 'validations' do
    it 'validates presence of title' do
      project = build(:project, title: nil)
      expect(project).not_to be_valid
    end
  end
end
