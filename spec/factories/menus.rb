FactoryBot.define do
  factory :menu do
    sequence(:name) { |n| "Menu #{n}" }
    description { "Sample menu description" }
    menu_type { "Starter" }
  end
end
