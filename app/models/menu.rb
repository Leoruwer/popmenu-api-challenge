class Menu < ApplicationRecord
  has_many :menu_items, dependent: :destroy

  validates :name, presence: true
  validates :menu_type, presence: true

  before_validation :parameterize_menu_type

  private

  def parameterize_menu_type
    return if menu_type.blank?

    self.menu_type = menu_type.parameterize
  end
end
