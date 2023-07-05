# frozen_string_literal: true

class BidNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "bid_notifications_channel_#{params[:user_id]}"
  end

  def unsubscribed; end
end
