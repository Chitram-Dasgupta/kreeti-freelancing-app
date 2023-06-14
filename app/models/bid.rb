class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :bid_name, presence: true

  enum bid_status: %i[pending accepted rejected]

  # scope :recent_by_user, ->(user) { where(user: user).order(created_at: :desc).limit(5) }

  scope :recent_by_user, ->(user) { where(user_id: user.id).order(created_at: :desc).limit(5) }
end
