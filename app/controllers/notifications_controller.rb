class NotificationsController < ApplicationController
  def count
    full_count = current_user.notifications.count
    count = current_user.notifications.where(read: false).count
    render json: { count:, full_count: }
  end

  def fetch_notifications
    limit = params[:limit] || current_user.notifications.count
    notifications = current_user.notifications.order('created_at DESC').limit(limit)
    render json: notifications.to_json(include: { actor: { only: :email }, project: { only: :title },
                                                  bid: { only: :bid_status } })
  end

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.update!(read: true)
    render json: { success: true }
  end

  def mark_all_as_read
    notifications = current_user.notifications.where(read: false)
    notifications.update_all(read: true)
    render json: { success: true }
  end

  def delete_read
    Notification.where(read: true).destroy_all
    render json: { success: true }
  end
end
