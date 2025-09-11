require "json"

puts "Deleting old data"
Restaurant.destroy_all
Menu.destroy_all
MenuItem.destroy_all

puts "Finding JSON file"
file_path = Rails.root.join("db", "seeds", "restaurant_data.json")

if File.exist?(file_path)
  puts "Importing JSON file"
  json_data = File.read(file_path)
  importer = JsonImporter.new(json_data)
  result = importer.call

  puts result[:message]

  result[:logs].each { |log| puts " - #{log}" }
else
  puts "Seed file not found: #{file_path}"
end
