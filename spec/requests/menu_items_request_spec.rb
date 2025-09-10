require "rails_helper"

RSpec.describe "MenuItemsRequest", type: :request do
  let!(:starter_menu) { create(:menu, name: "Starters", menu_type: "starter") }
  let!(:main_menu) { create(:menu, name: "Main Course", menu_type: "main-course") }

  before do
    create(:menu_item, name: "Bruschetta", price_in_cents: 700, restriction_type: :vegan, menu: starter_menu)
    create(:menu_item, name: "Garlic Bread", price_in_cents: 500, restriction_type: :no_restriction, menu: starter_menu)
    create(:menu_item, name: "Grilled Chicken", price_in_cents: 1800, restriction_type: :no_restriction, menu: main_menu)
  end

  describe "GET /menus/:menu_id/menu_items" do
    it "returns menu items for the given menu" do
      get "/menus/#{starter_menu.id}/menu_items", as: :json

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(2)
      expect(json.map { |item| item["name"] }).to contain_exactly("Bruschetta", "Garlic Bread")
    end

    it "does not return items from other menus" do
      get "/menus/#{main_menu.id}/menu_items", as: :json

      json = JSON.parse(response.body)

      expect(json.size).to eq(1)
      expect(json.first["name"]).to eq("Grilled Chicken")
    end
  end
end
