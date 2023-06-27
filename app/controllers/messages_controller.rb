class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)

    if @message.save
      logger.debug "Message saved"
    else
      logger.debug "Message NOT saved"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
