require "rails_helper"

RSpec.describe Restaurant, type: :model do
  describe "validations" do
    it "is invalid without a name" do
      restaurant = build(:restaurant, name: nil)
      expect(restaurant).not_to be_valid
    end

    it "validates uniqueness of name" do
      create(:restaurant, name: "UniqueName")
      restaurant = build(:restaurant, name: "UniqueName")
      expect(restaurant).not_to be_valid
    end
  end

  describe "associations" do
    it "has many menus" do
      assoc = described_class.reflect_on_association(:menus)
      expect(assoc.macro).to eq(:has_many)
    end
  end
end
