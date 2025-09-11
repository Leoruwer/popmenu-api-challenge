require "rails_helper"

RSpec.describe JsonImporter, type: :service do
  let(:valid_json) do
    {
      restaurants: [
        {
          name: "Restaurant Name",
          menus: [
            {
              name: "Lunch",
              menu_items: [
                { name: "Burger", price: 9.0 },
                { name: "Small Salad", price: 5.0 }
              ]
            },
            {
              name: "Dinner",
              menu_items: [
                { name: "Burger", price: 15.0 },
                { name: "Large Salad", price: 8.0 }
              ]
            }
          ]
        }
      ]
    }.to_json
  end

  let(:invalid_json) { "{ restaurants: [ { name: 'Broken JSON' } " }

  describe "#call" do
    context "with valid JSON" do
      it "imports restaurants, menus, and menu_items" do
        importer = JsonImporter.new(valid_json)
        result = importer.call

        expect(result[:success]).to be true
        expect(Restaurant.count).to eq(1)
        expect(Menu.count).to eq(2)
        expect(MenuItem.count).to eq(3) # Burger is shared between menus
        expect(Restaurant.first.menus.map(&:name)).to contain_exactly("Lunch", "Dinner")
        expect(MenuItem.pluck(:name)).to include("Burger", "Small Salad", "Large Salad")

        logs = result[:logs].join
        expect(logs).to include("Created restaurant")
        expect(logs).to include("Created menu")
        expect(logs).to include("Created menu item")
        expect(logs).to include("Linked")
      end
    end

    context "does not create duplicates if run twice" do
      it "does not create duplicate records and logs correctly" do
        JsonImporter.new(valid_json).call
        result = JsonImporter.new(valid_json).call

        expect(result[:success]).to be true
        expect(Restaurant.count).to eq(1)
        expect(Menu.count).to eq(2)
        expect(MenuItem.count).to eq(3)

        expect(result[:logs]).to include("Found existing restaurant: Restaurant Name")
        expect(result[:logs]).to include("Found existing menu: Lunch for restaurant: Restaurant Name")
        expect(result[:logs]).to include("Found existing menu item: Burger (9.0)")
      end
    end

    context "with names that differ only by spacing or case" do
      let(:json_with_spacing) do
        {
          restaurants: [
            {
              name: "Restaurant Name",
              menus: [
                {
                  name: "  lunch  ",
                  menu_items: [
                    { name: "Burger", price: 9.0 },
                    { name: "small salad", price: 5.0 },
                    { name: "smallsalad", price: 5.0 }
                  ]
                }
              ]
            }
          ]
        }.to_json
      end

      it "does not create duplicates due to spacing or case differences" do
        JsonImporter.new(valid_json).call
        result = JsonImporter.new(json_with_spacing).call

        expect(result[:success]).to be true

        expect(Restaurant.count).to eq(1)
        expect(Menu.count).to eq(2)
        expect(MenuItem.count).to eq(3)

        expect(result[:logs]).to include("Found existing restaurant: Restaurant Name")
        expect(result[:logs]).to include("Found existing menu: Lunch for restaurant: Restaurant Name")
        expect(result[:logs]).to include("Found existing menu item: Burger (9.0)")
      end
    end

    context "with invalid JSON" do
      it "returns an error" do
        importer = JsonImporter.new(invalid_json)
        result = importer.call

        expect(result[:success]).to be false
        expect(result[:logs].join).to include("Invalid JSON")
        expect(result[:error]).to include("expected object key") # This is part of the message from the ParseError
      end
    end

    context "logging" do
      it "logs creation messages" do
        importer = JsonImporter.new(valid_json)

        expect(Rails.logger).to receive(:info).at_least(:once)

        importer.call
      end
    end
  end
end
