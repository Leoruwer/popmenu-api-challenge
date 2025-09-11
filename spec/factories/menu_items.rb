FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "Item #{n}" }
    price_in_cents { 1000 }
    restriction_type { :no_restriction }

    after(:build) do |menu_item|
      menu_item.menus << build(:menu) if menu_item.menus.empty?
    end
  end
end
