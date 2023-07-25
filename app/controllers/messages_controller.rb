# frozen_string_literal: true

class MessagesController < ApplicationController
  def create
    room = Room.find(params[:room_id])
    message = room.messages.new(message_params)

    if message.save
      RoomChannel.broadcast_to(room, { content: message.content, user_id: message.user_id, status: 'sent' })
      render json: { status: 'ok' }
    else
      render json: { status: 'error', errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :room_id).merge(user: current_user)
  end
end
