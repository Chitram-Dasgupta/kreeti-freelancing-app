# frozen_string_literal: true

class UserRoom < ApplicationRecord
  belongs_to :room
  belongs_to :sender, class_name: 'User', inverse_of: :sender_rooms
  belongs_to :receiver, class_name: 'User', inverse_of: :receiver_rooms

  scope :belongs_to_user, ->(user) { where(sender_id: user.id).or(where(receiver_id: user.id)) }

  def other_user(user)
    user == sender ? receiver : sender
  end
end
