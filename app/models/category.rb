class Category < ApplicationRecord
  has_many :project_categories
  has_many :projects, through: :project_categories
  has_many :user_categories
  has_many :users, through: :user_categories
end
