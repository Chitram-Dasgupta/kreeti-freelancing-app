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

  private

  def message_params
    params.require(:message).permit(:content, :room_id)
  end
end
