# frozen_string_literal: true

class UserRoom < ApplicationRecord
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'
  belongs_to :room

  def other_user(user)
    user == user1 ? user2 : user1
  end
end
