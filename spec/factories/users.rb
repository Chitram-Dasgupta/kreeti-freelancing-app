# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    sequence(:username) { |n| "user#{n}" }
    role { 'client' }
    visibility { 'pub' }
    status { 'approved' }
    experience { 10 }
    confirmation_token { 'token' }
    confirmation_token_created_at { Time.current }
  end
end
