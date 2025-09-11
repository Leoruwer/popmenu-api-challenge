# Usage:
#   JSON input:
#     bin/rails json:import DATA='{"restaurants":[{"name":"Poppo's Cafe","menus":[{"name":"lunch","menu_items":[{"name":"Burger","price":9.0}]}]}]}'
#
#   From a file:
#     bin/rails json:import DATA="$(cat path/to/restaurant_data.json)"

namespace :json do
  desc "Import and parses JSON data. Pass the JSON string via ENV['DATA']"

  task import: :environment do
    json_data = ENV["DATA"]

    unless json_data && !json_data.strip.empty?
      puts "Please provide JSON data using DATA='your_json_here'"

      exit 1
    end

    importer = JsonImporter.new(json_data)
    result = importer.call

    if result[:success]
      puts "JSON imported successfully!"
    else
      puts "Import failed: #{result[:error]}"
    end
  end
end
