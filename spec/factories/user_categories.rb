# frozen_string_literal: true

FactoryBot.define do
  factory :user_category do
    user { association(:user) }
    category { association(:category) }
  end
end
