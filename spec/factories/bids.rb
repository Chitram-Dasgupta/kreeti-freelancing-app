# frozen_string_literal: true

FactoryBot.define do
  factory :bid do
    bid_description { 'test description' }
    bid_status { 'pending' }
    bid_amount { '9.99' }
    project_files_uploaded { false }
    user
    project
  end
end
