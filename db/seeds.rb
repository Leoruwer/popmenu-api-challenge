# Destroy old data
MenuItem.delete_all
Menu.delete_all
Restaurant.delete_all

# Create Restaurant
default_restaurant = Restaurant.create!(name: "Default Restaurant")

# Create Menus
starter_menu = Menu.create!(
  name: "Starters",
  description: "Light dishes to start your meal",
  menu_type: "Starter",
  restaurant: default_restaurant
)

main_course_menu = Menu.create!(
  name: "Main Course",
  description: "Hearty main dishes",
  menu_type: "Main Course",
  restaurant: default_restaurant
)

desserts_menu = Menu.create!(
  name: "Desserts",
  description: "Sweet treats to finish your meal",
  menu_type: "Desserts",
  restaurant: default_restaurant
)

drinks_menu = Menu.create!(
  name: "Drinks",
  description: "Beverages and cocktails",
  menu_type: "Drinks",
  restaurant: default_restaurant
)

# Starters
MenuItem.create!(name: "Bruschetta", price_in_cents: 700, restriction_type: :vegan, menus: [ starter_menu ])
MenuItem.create!(name: "Garlic Bread", price_in_cents: 500, restriction_type: :no_restriction, menus: [ starter_menu ])

# Main Course
MenuItem.create!(name: "Grilled Chicken", price_in_cents: 1800, restriction_type: :no_restriction, menus: [ main_course_menu ])
MenuItem.create!(name: "Vegan Burger", price_in_cents: 1600, restriction_type: :vegan, menus: [ main_course_menu ])

# Desserts
MenuItem.create!(name: "Chocolate Cake", price_in_cents: 900, restriction_type: :no_restriction, menus: [ desserts_menu ])
MenuItem.create!(name: "Vegan Sorbet", price_in_cents: 850, restriction_type: :vegan, menus: [ desserts_menu ])

# Drinks
MenuItem.create!(name: "Red Wine", price_in_cents: 1500, restriction_type: :no_restriction, menus: [ drinks_menu ])
MenuItem.create!(name: "Fresh Orange Juice", price_in_cents: 700, restriction_type: :no_restriction, menus: [ drinks_menu ])
