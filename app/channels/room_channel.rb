class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from 'room_channel'
    room = Room.find(params[:room_id])
    stream_for room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
