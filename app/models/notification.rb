# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :bid
  belongs_to :project
  belongs_to :recipient, class_name: 'User', inverse_of: :notifications

  validates :message, presence: true, length: { maximum: 255 }

  scope :read, -> { where(read: true) }
  scope :unread, -> { where(read: false) }

  default_scope { order(created_at: :desc) }

  def self.create_for_bid(bid)
    notification_message = "Your bid for #{project_title(bid)} is #{bid.bid_status}"
    notification = create_notification(bid.user_id, bid.project_id, bid.id, notification_message)
    broadcast_notification(notification, bid.user_id, bid.project_id)
  end

  def self.create_for_project_files_upload(bid)
    notification_message = "The freelancer #{bid.username} for #{project_title(bid)} submitted the project files"
    notification = create_notification(bid.project.user_id, bid.project_id, bid.id, notification_message)
    broadcast_notification(notification, bid.project.user_id, bid.project_id)
  end

  def self.create_notification(recipient_id, project_id, bid_id, message)
    create(
      recipient_id:,
      project_id:,
      bid_id:,
      message:,
      read: false
    )
  end

  def self.broadcast_notification(notification, user_id, project_id)
    ActionCable.server.broadcast(
      "bid_notifications_channel_#{user_id}", {
        message: notification.message,
        project_id:,
        notification_id: notification.id
      }
    )
  end

  def self.project_title(bid)
    bid.project_title
  end
end
