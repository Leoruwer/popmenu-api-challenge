class CreateRestaurants < ActiveRecord::Migration[8.0]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :restaurants, :name, unique: true
  end
end
