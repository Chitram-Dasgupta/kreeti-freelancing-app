# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    # rubocop:disable FactoryBot/AssociationStyle
    association :recipient, factory: :user
    # rubocop:enable FactoryBot/AssociationStyle
    project
    bid
    message { 'Test notification message' }
    read { false }
  end
end
