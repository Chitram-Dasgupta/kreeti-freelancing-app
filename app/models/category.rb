# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :project_categories, dependent: :destroy
  has_many :projects, through: :project_categories
  has_many :user_categories, dependent: :destroy
  has_many :users, through: :user_categories

  validates :name, presence: true, uniqueness: true

  default_scope { order(:name) }
end
