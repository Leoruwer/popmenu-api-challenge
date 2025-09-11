class DeleteDuplicatesFromMenuItems < ActiveRecord::Migration[8.0]
  def up
    MenuItem.group(:name).having("count(*) > 1").pluck(:name).each do |duplicated_name|
      items = MenuItem.where(name: duplicated_name).order(:id)
      keep = items.first

      items.offset(1).each do |item|
        item.menus.each do |menu|
          keep.menus << menu unless keep.menus.exists?(menu.id)
        end

      item.destroy
      end
    end
  end
end
