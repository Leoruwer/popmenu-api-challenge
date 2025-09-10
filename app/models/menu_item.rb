class MenuItem < ApplicationRecord
  belongs_to :menu

  enum :restriction_type, { no_restriction: 0, vegan: 1, lactose_free: 2, gluten_free: 3 }

  validates :name, presence: true
  validates :price_in_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :vegan, -> { where(restriction_type: :vegan) }
  scope :lactose_free, -> { where(restriction_type: :lactose_free) }
  scope :gluten_free, -> { where(restriction_type: :gluten_free) }

  def price
    price_in_cents.to_f / 100
  end
end
