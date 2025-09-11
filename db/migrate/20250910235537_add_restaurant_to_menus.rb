class AddRestaurantToMenus < ActiveRecord::Migration[8.0]
  # Assigned a fake restaurant to existing menus and then make FK not nullable
  def up
    default_restaurant = Restaurant.find_or_create_by!(name: "No restaurant assigned")

    add_reference :menus, :restaurant, foreign_key: true

    Menu.reset_column_information
    Menu.update_all(restaurant_id: default_restaurant.id)

    change_column_null :menus, :restaurant_id, false
  end

  def down
    remove_reference :menus, :restaurant, foreign_key: true
  end
end
