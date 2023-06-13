class Profile < ApplicationRecord
  belongs_to :user

  has_one_attached :profile_picture

  validates :name, length: { maximum: 255 }
  validates :experience, numericality: { only_integer: true, allow_nil: true, less_than_or_equal_to: 100 }
end
