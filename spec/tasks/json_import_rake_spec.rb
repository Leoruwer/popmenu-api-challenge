require "rails_helper"
require "rake"

RSpec.describe "json:import", type: :task do
  before :all do
    Rake.application.rake_require("tasks/json_import")
    Rake::Task.define_task(:environment)
  end

  let(:task) { Rake::Task["json:import"] }
  let(:valid_json) do
    {
      restaurants: [
        {
          name: "Rake Test Cafe",
          menus: [
            {
              name: "Lunch",
              menu_items: [
                { name: "Burger", price: 9.0 },
                { name: "Salad", price: 5.0 }
              ]
            }
          ]
        }
      ]
    }.to_json
  end

  after do
    task.reenable
  end

  context "with valid JSON" do
    it "imports the data successfully" do
      ENV["DATA"] = valid_json

      expect { task.invoke }.to change(Restaurant, :count).by(1)
                                                          .and change(Menu, :count).by(1)
                                                          .and change(MenuItem, :count).by(2)
    ensure
      ENV.delete("DATA")
    end
  end

  context "without DATA environment variable" do
    it "outputs an error message and does not create records" do
      ENV.delete("DATA")

      expect { task.invoke }.to output(/Please provide JSON data/).to_stdout
      expect(Restaurant.count).to eq(0)
    end
  end

  context "with invalid JSON" do
    it "outputs an error message" do
      ENV["DATA"] = "{ restaurants: [ { name: 'Broken JSON' } "

      expect { task.invoke }.to output(/Import failed:/).to_stdout
      expect(Restaurant.count).to eq(0)
    ensure
      ENV.delete("DATA")
    end
  end
end
