require "rails_helper"

RSpec.describe "MenusRequest", type: :request do
  let!(:restaurant) { create(:restaurant, name: "Sample Restaurant") }
  let!(:starter_menu) { create(:menu, name: "Starters", menu_type: "starter", restaurant: restaurant) }
  let!(:main_menu) { create(:menu, name: "Main Course", menu_type: "main-course", restaurant: restaurant) }

  before do
    create(:menu_item, name: "Bruschetta", price_in_cents: 700, restriction_type: :vegan, menus: [ starter_menu ])
    create(:menu_item, name: "Grilled Chicken", price_in_cents: 1800, restriction_type: :no_restriction, menus: [ main_menu ])
  end

  describe "GET /restaurants/:restaurant_id/menus/:id" do
    it "returns a specific menu with its menu items" do
      get "/restaurants/#{restaurant.id}/menus/#{starter_menu.id}"

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
