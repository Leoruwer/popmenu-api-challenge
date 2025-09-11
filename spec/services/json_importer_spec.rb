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
      end

      it "does not create duplicates if run twice" do
        importer = JsonImporter.new(valid_json)
        importer.call

        expect { importer.call }.not_to change(Restaurant, :count)
        expect { importer.call }.not_to change(Menu, :count)
        expect { importer.call }.not_to change(MenuItem, :count)

        lunch_menu = Menu.find_by(name: "Lunch")
        dinner_menu = Menu.find_by(name: "Dinner")

        expect(lunch_menu.menu_items.pluck(:name)).to contain_exactly("Burger", "Small Salad")
        expect(dinner_menu.menu_items.pluck(:name)).to contain_exactly("Burger", "Large Salad")
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
        importer = JsonImporter.new(valid_json)
        importer.call

        importer_spacing = JsonImporter.new(json_with_spacing)
        importer_spacing.call

        expect(Restaurant.count).to eq(1)
        expect(Menu.count).to eq(2)
        expect(MenuItem.count).to eq(3)

        lunch_menu = Menu.find_by(name: "Lunch")
        expect(lunch_menu.menu_items.pluck(:name)).to include("Burger", "Small Salad")
      end
    end

    context "with invalid JSON" do
      it "returns an error" do
        importer = JsonImporter.new(invalid_json)
        result = importer.call

        expect(result[:success]).to be false
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
