# frozen_string_literal: true

class ProjectCategory < ApplicationRecord
  belongs_to :project
  belongs_to :category
end
