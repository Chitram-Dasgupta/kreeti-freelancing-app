# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    name { 'MyString' }
    qualification { 'MyString' }
    experience { 1 }
    industry { 'MyString' }
    user { nil }
  end
end
