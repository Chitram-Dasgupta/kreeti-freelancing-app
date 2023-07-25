# frozen_string_literal: true

class NotificationsController < ApplicationController
  def count
    notifications = current_user.notifications
    full_count = notifications.count
    unread_count = notifications.where(read: false).count
    render json: { unread_count:, full_count: }
  end

  def delete_read
    current_user.notifications.where(read: true).destroy_all
    render json: { success: true }
  end

  def fetch_notifications
    current_notifications = current_user.notifications
    limit = params[:limit] || current_notifications.count
    notifications = current_notifications.includes(:project, :bid).limit(limit)
    render json: notifications.to_json(include: { project: { only: :title },
                                                  bid: { only: :bid_status } })
  end

  def mark_all_as_read
    notifications = current_user.notifications.where(read: false)
    success = true
    notifications.each do |notification|
      unless notification.update(read: true)
        success = false
        break
      end
    end
    render json: { success: }
  end

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)
    render json: { success: true }
  end
end
