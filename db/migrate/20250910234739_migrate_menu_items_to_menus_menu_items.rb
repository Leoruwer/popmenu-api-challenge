class MigrateMenuItemsToMenusMenuItems < ActiveRecord::Migration[8.0]
  def up
    Menu.includes(:menu_items).find_each do |menu|
      menu.menu_items.each do |item|
        unless ActiveRecord::Base.connection.execute(
          "SELECT 1 FROM menu_items_menus WHERE menu_id=#{menu.id} AND menu_item_id=#{item.id}"
        ).any?
          ActiveRecord::Base.connection.execute(
            "INSERT INTO menu_items_menus (menu_id, menu_item_id) VALUES (#{menu.id}, #{item.id})"
          )
        end
      end
    end
  end

  def down
    execute "DELETE FROM menu_items_menus"
  end
end
