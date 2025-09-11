class JsonImporter
  def initialize(data)
    @data = data
  end

  def call
    parsed = JSON.parse(@data)
    restaurants = parsed["restaurants"] || []

    restaurants.each do |restaurant_data|
      import_restaurant(restaurant_data)
    end

    { success: true, message: "Data imported successfully" }
  rescue JSON::ParserError => e
    Rails.logger.error "Invalid JSON: #{e.message}"

    { success: false, error: e.message }
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Record invalid: #{e.message}"

    { success: false, error: e.message }
  rescue StandardError => e
    Rails.logger.error "Unexpected error: #{e.message}"

    { success: false, error: e.message }
  end

  private

  def import_restaurant(data)
    name = data["name"].to_s.strip
    normalized_name = normalize_name(name)

    restaurant = Restaurant.all.detect { |r| normalize_name(r.name.to_s) == normalized_name } || Restaurant.find_or_initialize_by(name: name)

    if restaurant.new_record?
      restaurant.save!

      Rails.logger.info "Created restaurant: #{restaurant.name}"
    else
      Rails.logger.info "Found existing restaurant: #{restaurant.name}"
    end

    menus = data["menus"] || []

    menus.each do |menu_data|
      import_menu(restaurant, menu_data)
    end
  end

  def import_menu(restaurant, data)
    menu_name = data["name"].to_s.strip
    normalized_name = normalize_name(menu_name)
    menu_type = data["menu_type"].presence || menu_name

    # We use the normalize_name function for comparison only (not for storing in DB) to handle minor differences
    # in formatting, spacing, or capitalization. This prevents creating duplicate records for
    # menus or menu items that are essentially the same but formatted differently in the JSON
    menu = restaurant.menus.detect { |m| normalize_name(m.name.to_s) == normalized_name } || restaurant.menus.find_or_initialize_by(name: menu_name)

    # Set the menu_type to the provided value or fallback to the menu name.
    # The idea of menu_type is to categorize menus that are conceptually similar across different restaurants
    # For example, in a Japanese restaurant:
    #   - Menu: "Salads", menu_type: "Starter" -> items: [list of Salads]
    #   - Menu: "Sushis", menu_type: "Main Course" -> items: [list of Sushi]
    #   - Menu: "Hot Philladelphia", menu_type: "Main Course" -> items: [list of Hot Philladelphia]
    # menu_type helps group similar types of menus, while the menu name remains descriptive
    menu.menu_type ||= menu_type

    if menu.new_record?
      menu.save!

      Rails.logger.info "Created menu: #{menu.name} for restaurant #{restaurant.name}"
    else
      Rails.logger.info "Found existing menu: #{menu.name} for restaurant #{restaurant.name}"
    end

    items = data["menu_items"] || data["dishes"] || []

    items.each do |item_data|
      import_menu_item(menu, item_data)
    end
  end

  def import_menu_item(menu, data)
    name = data["name"].to_s.strip.gsub(/\\"/, '"')
    normalized_name = normalize_name(name)

    item = MenuItem.all.detect { |i| normalize_name(i.name.to_s) == normalized_name } || MenuItem.find_or_initialize_by(name: name, price_in_cents: (BigDecimal(data["price"].to_s) * 100).to_i)

    if item.new_record?
      item.save!
      Rails.logger.info "Created menu item: #{item.name} (#{item.price})"
    else
      Rails.logger.info "Found existing menu item: #{item.name} (#{item.price})"
    end

    unless menu.menu_items.exists?(item.id)
      menu.menu_items << item

      Rails.logger.info "Linked #{item.name} to menu #{menu.name}"
    else
      Rails.logger.info "Menu #{menu.name} already has item #{item.name}"
    end
  end

  def normalize_name(name)
    name.downcase.gsub(/\s+/, "")
  end
end
