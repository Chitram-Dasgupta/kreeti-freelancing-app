FactoryBot.define do
  factory :notification do
    recipient { nil }
    actor { nil }
    project { nil }
    bid { nil }
    bid_status { 1 }
    read { false }
  end
end
