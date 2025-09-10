require "rails_helper"

RSpec.describe "Menus endpoint", type: :request do
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
end
