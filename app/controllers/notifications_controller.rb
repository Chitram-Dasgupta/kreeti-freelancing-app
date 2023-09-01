# frozen_string_literal: true

class NotificationsController < ApplicationController
  def count
    notifications = current_user.notifications
    full_count = notifications.count
    unread_count = notifications.unread.count
    render json: { unread_count:, full_count: }
  end

  def delete_read
    current_user.notifications.read.destroy_all
    render_success_response true
  end

  def fetch_notifications
    current_notifications = current_user.notifications
    limit = params[:limit] || current_notifications.count
    notifications = current_notifications.includes(:project, :bid).limit(limit)
    render json: notifications.to_json(include: { project: { only: :title },
                                                  bid: { only: :bid_status } })
  end

  def mark_all_as_read
    notifications = current_user.notifications.unread
    success = true
    notifications.each do |notification|
      unless notification.update(read: true)
        success = false
        break
      end
    end
    render_success_response success
  end

  def mark_as_read
    notification = current_user.notifications.find_by(id: params[:id])
    return render json: { success: false } if notification.nil?

    notification.update(read: true)
    render_success_response true
  end

  private

  def render_success_response(success)
    render json: { success: }
  end
end
