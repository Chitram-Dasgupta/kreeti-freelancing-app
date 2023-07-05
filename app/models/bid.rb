# frozen_string_literal: true

class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :project

  after_save :send_notifications, :update_project

  enum bid_status: { pending: 0, accepted: 1, rejected: 2, awarded: 3 }

  validates :bid_name, presence: true
  validates :bid_amount, presence: true, numericality: { greater_than: 0, less_than: 1_000_000 }
  validates :user_id, uniqueness: { scope: :project_id }

  delegate :username, to: :user

  scope :recent_by_user, ->(user) { where(user_id: user.id).order(created_at: :desc).limit(5) }

  def accept
    update(bid_status: 'accepted')
  end

  def reject
    update(bid_status: 'rejected')
  end

  def hold
    update(bid_status: 'pending')
  end

  def award
    update(bid_status: 'awarded')
    project.bids.where.not(id:).find_each { |b| b.update(bid_status: :rejected) }
  end

  def modifiable?
    bid_status == 'pending' || bid_status == 'accepted'
  end

  private

  def send_notifications
    return unless bid_status_changed?

    Notification.create_for_bid(self)
  end

  def bid_status_changed?
    saved_change_to_attribute?(:bid_status)
  end

  def update_project
    if bid_status == 'awarded'
      project.update(has_awarded_bid: true)
    elsif bid_status_was == 'awarded'
      project.update(has_awarded_bid: false)
    end
  end
end
