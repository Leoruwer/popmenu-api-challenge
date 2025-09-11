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
      it "imports the data successfully" do
        post "/import", params: valid_json, headers: { "CONTENT_TYPE" => "application/json" }

        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json["message"]).to eq("Data imported successfully")

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
