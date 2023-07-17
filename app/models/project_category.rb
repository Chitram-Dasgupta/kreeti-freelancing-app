# frozen_string_literal: true

class ProjectCategory < ApplicationRecord
  belongs_to :category
  belongs_to :project
end
