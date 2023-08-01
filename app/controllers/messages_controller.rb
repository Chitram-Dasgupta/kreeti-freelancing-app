# frozen_string_literal: true

class MessagesController < ApplicationController
  def create
    room = Room.find(params[:room_id])
    result = Message.create_and_broadcast(room, message_params)

    if result[:status] == 'ok'
      render json: { status: 'ok' }
    else
      render json: result, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :room_id).merge(user: current_user)
  end
end
