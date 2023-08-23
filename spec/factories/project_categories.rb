# frozen_string_literal: true

FactoryBot.define do
  factory :project_category do
    project { association(:project) }
    category { association(:category) }
  end
end
