# frozen_string_literal: true

class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :project

  has_one_attached :bid_code_document
  has_one_attached :bid_design_document
  has_one_attached :bid_other_document

  after_save :send_notifications, :update_project

  enum bid_status: { pending: 0, accepted: 1, rejected: 2 }

  validates :bid_name, presence: true
  validates :bid_amount, presence: true, numericality: { greater_than: 0, less_than: 1_000_000 }
  validates :user_id, uniqueness: { scope: :project_id }

  delegate :username, to: :user

  scope :recent_by_user, ->(user) { where(user_id: user.id).order(created_at: :desc).limit(5) }

  default_scope { order(:created_at) }

  def accept
    update(bid_status: 'accepted')
    project.bids.where.not(id:).find_each { |b| b.update(bid_status: 'rejected') }
  end

  def reject
    update(bid_status: 'rejected')
  end

  def modifiable?
    bid_status == 'pending'
  end

  def accepted?
    bid_status == 'accepted'
  end

  def rejected?
    bid_status == 'rejected'
  end

  def upload_project_files
    project.complete
  end

  private

  def send_notifications
    if bid_status_changed?
      Notification.create_for_bid(self)
    elsif project_files_uploaded_changed?
      Notification.create_for_project_files_upload(self)
    end
  end

  def bid_status_changed?
    saved_change_to_attribute?(:bid_status)
  end

  def project_files_uploaded_changed?
    saved_change_to_attribute?(:project_files_uploaded)
  end

  def update_project
    return unless bid_status == 'accepted'

    project.update(has_awarded_bid: true)
  end
end
