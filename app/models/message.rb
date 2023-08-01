# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :content, presence: true, length: { maximum: 255 }

  def self.create_and_broadcast(room, params)
    message = room.messages.new(params)

    if message.save
      RoomChannel.broadcast_to(room, { content: message.content, user_id: message.user_id, status: 'sent' })
      { status: 'ok' }
    else
      { status: 'error', errors: message.errors.full_messages }
    end
  end
end
