class MenuItem < ApplicationRecord
  has_and_belongs_to_many :menus

  enum :restriction_type, { no_restriction: 0, vegan: 1, lactose_free: 2, gluten_free: 3 }

  validates :name, presence: true, uniqueness: true
  validates :price_in_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def price
    price_in_cents.to_f / 100
  end

  def self.with_restrictions(*types)
    where(restriction_type: restriction_types.values_at(*types).compact)
  end
end
