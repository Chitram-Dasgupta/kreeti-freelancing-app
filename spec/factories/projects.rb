# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { 'MyString' }
    description { 'MyText' }
    visibility { 1 }
    design_document { 'MyString' }
    srs_document { 'MyString' }
    user { nil }
  end
end
