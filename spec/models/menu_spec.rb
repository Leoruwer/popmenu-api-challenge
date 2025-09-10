require "rails_helper"

RSpec.describe Menu, type: :model do
  describe "validations" do
    it "is invalid without a name" do
      menu = build(:menu, name: nil)

      expect(menu).not_to be_valid
    end

    it "is invalid without a menu_type" do
      menu = build(:menu, menu_type: nil)

      expect(menu).not_to be_valid
    end
  end

  describe "factories" do
    it "has a valid factory" do
      expect(build(:menu)).to be_valid
    end
  end

  describe "callbacks" do
    it "parameterizes menu_type before validation" do
      menu = build(:menu, menu_type: "Main Course")
      menu.valid?
      expect(menu.menu_type).to eq("main-course")
    end
  end
end
