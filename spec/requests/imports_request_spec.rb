require "rails_helper"

RSpec.describe "ImportsRequest", type: :request do
  let(:valid_json) do
    {
      restaurants: [
        {
          name: "Restaurant Name",
          menus: [
            {
              name: "lunch",
              menu_items: [
                { name: "Burger", price: 9.00 },
                { name: "Small Salad", price: 5.00 }
              ]
            }
          ]
        }
      ]
    }.to_json
  end

  let(:invalid_json) { "{ restaurants: [ { name: 'Broken JSON' } " }

  describe "POST /import" do
    context "with valid JSON" do
      it "imports the data successfully and returns logs" do
        post "/import", params: valid_json, headers: { "CONTENT_TYPE" => "application/json" }

        json = JSON.parse(response.body)
        logs = json["logs"]

        expect(response).to have_http_status(:ok)
        expect(json["message"]).to eq("Data imported successfully")

        expect(logs).to include("Created restaurant: Restaurant Name")
        expect(logs).to include("Created menu: lunch for restaurant: Restaurant Name")
        expect(logs).to include("Created menu item: Burger (9.0)")
        expect(logs).to include("Linked Burger to menu lunch")
        expect(logs).to include("Created menu item: Small Salad (5.0)")
        expect(logs).to include("Linked Small Salad to menu lunch")

        expect(Restaurant.count).to eq(1)
        expect(Menu.count).to eq(1)
        expect(MenuItem.count).to eq(2)
      end
    end

    context "with invalid JSON" do
      it "returns an error" do
        post "/import", params: invalid_json, headers: { "CONTENT_TYPE" => "application/json" }

        json = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_content)
        expect(json["message"]).to include("expected object key") # This is part of the message from the ParseError
      end
    end
  end
end
