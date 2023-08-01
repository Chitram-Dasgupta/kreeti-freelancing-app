# frozen_string_literal: true

class Bid < ApplicationRecord
  paginates_per 12

  after_save :send_notifications, :update_project

  enum bid_status: { pending: 0, accepted: 1, rejected: 2 }

  belongs_to :project
  belongs_to :user

  has_many :notifications, dependent: :destroy

  has_one_attached :bid_code_document
  has_one_attached :bid_design_document
  has_one_attached :bid_other_document

  validates :bid_description, length: { maximum: 1024 }
  validates :bid_amount, presence: true, numericality: { greater_than: 0, less_than: 1_000_000 }
  validates :user_id, uniqueness: { scope: :project_id }

  delegate :title, to: :project, prefix: true
  delegate :username, to: :user, allow_nil: true

  scope :to_freelancer_or_awardee_client, lambda { |user|
    where(user:).or(where(project: user.projects))
  }

  default_scope { order(created_at: :desc) }

  def accept
    return unless modifiable?

    update(bid_status: 'accepted')
    project.bids.where.not(id:).find_each { |other_bid| other_bid.update(bid_status: 'rejected') }
  end

  def reject
    return unless modifiable?

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
    update(project_files_uploaded: true)
  end

  private

  def bid_status_changed?
    saved_change_to_attribute?(:bid_status)
  end

  def project_files_uploaded_changed?
    saved_change_to_attribute?(:project_files_uploaded)
  end

  def send_notifications
    if bid_status_changed?
      Notification.create_for_bid(self)
    elsif project_files_uploaded_changed?
      Notification.create_for_project_files_upload(self)
    end
  end

  def update_project
    return unless bid_status == 'accepted'

    project.update(has_awarded_bid: true)
  end
end
