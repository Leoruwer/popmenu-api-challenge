FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "Item #{n}" }
    price_in_cents { 1000 }
    restriction_type { :no_restriction }
    association :menu
  end
end
