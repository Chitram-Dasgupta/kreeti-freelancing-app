# frozen_string_literal: true

FactoryBot.define do
  factory :user_room do
    user1 { association(:user) }
    user2 { association(:user) }
    room { association(:room) }
  end
end
