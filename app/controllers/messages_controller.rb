class MessagesController < ApplicationController
  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params)

    RoomChannel.broadcast_to(@room, { content: @message.content, user_id: @message.user_id }) if @message.save

    respond_to do |format|
      format.html { redirect_to @room }
      format.js
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :room_id).merge(user: current_user)
  end
end
