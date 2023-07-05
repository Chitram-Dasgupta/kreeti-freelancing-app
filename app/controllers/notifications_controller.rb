class NotificationsController < ApplicationController
  def count
    notifications = current_user.notifications
    full_count = notifications.count
    unread_count = notifications.where(read: false).count
    render json: { unread_count:, full_count: }
  end

  def fetch_notifications
    limit = params[:limit] || current_user.notifications.count
    notifications = current_user.notifications.includes(:project, :bid).order(created_at: :desc).limit(limit)
    render json: notifications.to_json(include: { project: { only: :title },
                                                  bid: { only: :bid_status } })
  end

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)
    render json: { success: true }
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

  def delete_read
    current_user.notifications.where(read: true).destroy_all
    render json: { success: true }
  end
end
