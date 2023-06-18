class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :bid_name, presence: true

  enum bid_status: %i[pending accepted rejected awarded]

  delegate :email, to: :user

  scope :recent_by_user, ->(user) { where(user_id: user.id).order(created_at: :desc).limit(5) }

  def accept
    update(bid_status: :accepted)
  end

  def reject
    update(bid_status: :rejected)
  end

  def hold
    update(bid_status: :pending)
  end

  def award
    update(bid_status: :awarded)
    project.bids.where.not(id:).update_all(bid_status: :rejected)
  end

  def modifiable?
    bid_status == 'pending' || bid_status == 'accepted'
  end
end
