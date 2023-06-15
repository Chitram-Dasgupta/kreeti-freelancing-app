class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :bid_name, presence: true

  enum bid_status: %i[pending accepted rejected]

  scope :recent_by_user, ->(user) { where(user_id: user.id).order(created_at: :desc).limit(5) }

  def accept
    self.update(bid_status: :accepted)
    # project.bids.where.not(id: self.id).update_all(bid_status: :rejected)
  end

  def reject
    self.update(bid_status: :rejected)
    # project.bids.where.not(id: self.id).update_all(bid_status: :rejected)
  end

  def hold
    self.update(bid_status: :pending)
    # project.bids.where.not(id: self.id).update_all(bid_status: :rejected)
  end
end
