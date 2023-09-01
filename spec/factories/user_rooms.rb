# frozen_string_literal: true

FactoryBot.define do
  factory :user_room do
    sender { association(:user) }
    receiver { association(:user) }
    room { association(:room) }
  end
end
