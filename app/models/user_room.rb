# frozen_string_literal: true

class UserRoom < ApplicationRecord
  belongs_to :room
  belongs_to :user1, class_name: 'User', inverse_of: :user1_rooms
  belongs_to :user2, class_name: 'User', inverse_of: :user2_rooms

  scope :belongs_to_user, ->(user) { where(user1_id: user.id).or(where(user2_id: user.id)) }

  def other_user(user)
    user == user1 ? user2 : user1
  end
end
