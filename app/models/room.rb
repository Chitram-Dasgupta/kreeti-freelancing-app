# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :users, through: :user_rooms
  has_many :user_rooms, dependent: :destroy

  scope :for_user, lambda { |user_id|
                     joins(:user_rooms).where('user_rooms.sender_id = ? OR user_rooms.receiver_id = ?',
                                              user_id, user_id).order('updated_at DESC')
                   }
end
