require "rails_helper"

RSpec.describe MenuItem, type: :model do
  let(:name) { "Sample Item" }
  let(:price_in_cents) { 1500 }
  let(:restriction_type) { :no_restriction }

  let(:menu) { create(:menu) }
  let(:menu_item) { build(:menu_item, menu: menu, name: name, price_in_cents: price_in_cents, restriction_type: restriction_type) }

  describe "validations" do
    it "is invalid without a name" do
      menu_item.name = nil

      expect(menu_item).not_to be_valid
    end

    it "is invalid without a price_in_cents" do
      menu_item.price_in_cents = nil

      expect(menu_item).not_to be_valid
    end

    it "is invalid with a negative price_in_cents" do
      menu_item.price_in_cents = -100

      expect(menu_item).not_to be_valid
    end

    it "is invalid with a float price_in_cents" do
      menu_item.price_in_cents = 100.50

      expect(menu_item).not_to be_valid
    end

    it "raises an error with an invalid restriction_type" do
      expect {
        menu_item.restriction_type = :invalid
      }.to raise_error(ArgumentError)
    end

    it "accepts valid restriction_type values" do
      menu_item.restriction_type = :vegan

      expect(menu_item).to be_valid
    end
  end

  describe "scopes" do
    let!(:item_none) { create(:menu_item, menu: menu, restriction_type: :no_restriction) }
    let!(:item_vegan) { create(:menu_item, menu: menu, restriction_type: :vegan) }
    let!(:item_lactose) { create(:menu_item, menu: menu, restriction_type: :lactose_free) }
    let!(:item_gluten) { create(:menu_item, menu: menu, restriction_type: :gluten_free) }

    it "returns only vegan items" do
      expect(MenuItem.with_restrictions(:vegan)).to contain_exactly(item_vegan)
    end

    it "returns only lactose_free items" do
      expect(MenuItem.with_restrictions(:lactose_free)).to contain_exactly(item_lactose)
    end

    it "returns only gluten_free items" do
      expect(MenuItem.with_restrictions(:gluten_free)).to contain_exactly(item_gluten)
    end

    it "returns vegan and gluten_free items when multiple restrictions are passed" do
      expect(MenuItem.with_restrictions(:vegan, :gluten_free)).to contain_exactly(item_vegan, item_gluten)
    end

    it "returns nothing when no valid restrictions are passed" do
      expect(MenuItem.with_restrictions(:invalid)).to be_empty
    end
  end

  describe "associations" do
    it { should belong_to(:menu) }
  end

  describe "enums" do
    it { should define_enum_for(:restriction_type).with_values(no_restriction: 0, vegan: 1, lactose_free: 2, gluten_free: 3) }
  end

  describe "factories" do
    it "has a valid factory" do
      expect(build(:menu_item)).to be_valid
    end
  end

  describe "functions" do
    it "price returns the correct dollar amount" do
      menu_item.price_in_cents = 1234

      expect(menu_item.price).to eq(12.34)
    end
  end
end
