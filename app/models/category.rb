class Category < ApplicationRecord
  has_many :project_categories, dependent: :destroy
  has_many :projects, through: :project_categories
  has_many :user_categories, dependent: :destroy
  has_many :users, through: :user_categories
end
