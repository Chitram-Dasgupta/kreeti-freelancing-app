class NotificationsController < ApplicationController
  def count
    count = current_user.notifications.where(read: false).count
    render json: { count: }
  end

  def fetch_notifications
    notifications = current_user.notifications.order('created_at DESC').limit(10)
    render json: notifications.to_json(include: { actor: { only: :email }, project: { only: :title },
                                                  bid: { only: :bid_status } })
  end

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.update!(read: true)
    render json: { success: true }
  end
end
