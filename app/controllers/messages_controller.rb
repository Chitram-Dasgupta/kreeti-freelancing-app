class MessagesController < ApplicationController
  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params)

    if @message.save
      logger.debug 'Message saved'
      ActionCable.server.broadcast 'room_channel', { content: @message.content }
    else
      logger.debug 'Message NOT saved'
    end

    respond_to do |format|
      format.html { redirect_to @room }
      format.js
    end
  end

  # def create
  #   @room = Room.find(params[:room_id])
  #   if UserRoom.where(room_id: @room.id, user_id: [current_user.id, params[:user_id]]).count == 2
  #     @message = @room.messages.new(message_params)

  #     if @message.save
  #       ActionCable.server.broadcast 'room_channel', { content: @message.content }
  #     else
  #       # Handle save failure
  #     end
  #   else
  #     # Handle unauthorized access
  #   end
  # end

  private

  def message_params
    params.require(:message).permit(:content, :room_id)
  end
end
