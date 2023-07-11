# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User', inverse_of: :notifications
  belongs_to :project
  belongs_to :bid

  validates :message, presence: true, length: { maximum: 255 }

  default_scope { order(created_at: :desc) }

  def self.create_for_bid(bid)
    bid_project_title = Project.find_by(id: bid.project_id).title
    notification = create_notification_for_bid(bid, bid_project_title)
    broadcast_notification_for_bid(notification, bid, bid_project_title)
  end

  def self.create_notification_for_bid(bid, bid_project_title)
    create(
      recipient_id: bid.user_id,
      project_id: bid.project_id,
      bid_id: bid.id,
      message: "Your bid for #{bid_project_title} is #{bid.bid_status}",
      read: false
    )
  end

  def self.broadcast_notification_for_bid(notification, bid, bid_project_title)
    ActionCable.server.broadcast(
      "bid_notifications_channel_#{bid.user_id}", {
        message: "Your bid for #{bid_project_title} is #{bid.bid_status}",
        project_id: bid.project_id,
        notification_id: notification.id
      }
    )
  end

  def self.create_for_project_files_upload(bid)
    bid_project_title = Project.find_by(id: bid.project_id).title
    notification = create_notification_for_files_upload(bid, bid_project_title)
    broadcast_notification_for_files_upload(notification, bid, bid_project_title)
  end

  def self.create_notification_for_files_upload(bid, bid_project_title)
    create(
      recipient_id: bid.project.user_id,
      project_id: bid.project_id,
      bid_id: bid.id,
      message: "The freelancer #{bid.username} for #{bid_project_title} has submitted the project files",
      read: false
    )
  end

  def self.broadcast_notification_for_files_upload(notification, bid, bid_project_title)
    ActionCable.server.broadcast(
      "bid_notifications_channel_#{bid.project.user_id}", {
        message: "The freelancer #{bid.username} for #{bid_project_title} has submitted the project files",
        project_id: bid.project_id,
        notification_id: notification.id
      }
    )
  end
end
