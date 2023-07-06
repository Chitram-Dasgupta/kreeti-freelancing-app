# frozen_string_literal: true

FactoryBot.define do
  factory :bid do
    bid_name { 'MyString' }
    bid_description { 'MyText' }
    bid_status { 1 }
    bid_amount { '9.99' }
    bid_code_document { 'MyString' }
    bid_design_document { 'MyString' }
    bid_other_document { 'MyString' }
    project { nil }
  end
end
