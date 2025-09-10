require "rails_helper"

RSpec.describe "MenusController", type: :request do
  let!(:starter_menu) { create(:menu, name: "Starters", menu_type: "starter") }
  let!(:main_menu) { create(:menu, name: "Main Course", menu_type: "main-course") }

  before do
    create(:menu_item, name: "Bruschetta", price_in_cents: 700, restriction_type: :vegan, menu: starter_menu)
    create(:menu_item, name: "Grilled Chicken", price_in_cents: 1800, restriction_type: :no_restriction, menu: main_menu)
  end

  describe "GET /menus" do
    it "returns all menus with menu items" do
      get "/menus"

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(2)
      expect(json.first["menu_items"].first["name"]).to eq("Grilled Chicken")
    end
  end

  describe "GET /menus/:id" do
    it "returns a specific menu with its menu items" do
      get "/menus/#{starter_menu.id}"

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["id"]).to eq(starter_menu.id)
      expect(json["name"]).to eq("Starters")

      expect(json["menu_items"].size).to eq(1)
      expect(json["menu_items"].first["name"]).to eq("Bruschetta")
      expect(json["menu_items"].first["price"]).to eq(7.0)
    end
  end
end
