# Destroy old data
MenuItem.delete_all
Menu.delete_all

# Create Menus
starter_menu = Menu.create!(
  name: "Starters",
  description: "Light dishes to start your meal",
  menu_type: "Starter"
)

main_course_menu = Menu.create!(
  name: "Main Course",
  description: "Hearty main dishes",
  menu_type: "Main Course"
)

desserts_menu = Menu.create!(
  name: "Desserts",
  description: "Sweet treats to finish your meal",
  menu_type: "Desserts"
)

drinks_menu = Menu.create!(
  name: "Drinks",
  description: "Beverages and cocktails",
  menu_type: "Drinks"
)

# Starters
MenuItem.create!(name: "Bruschetta", price_in_cents: 700, restriction_type: :vegan, menu: starter_menu)
MenuItem.create!(name: "Garlic Bread", price_in_cents: 500, restriction_type: :no_restriction, menu: starter_menu)

# Main Course
MenuItem.create!(name: "Grilled Chicken", price_in_cents: 1800, restriction_type: :no_restriction, menu: main_course_menu)
MenuItem.create!(name: "Vegan Burger", price_in_cents: 1600, restriction_type: :vegan, menu: main_course_menu)

# Desserts
MenuItem.create!(name: "Chocolate Cake", price_in_cents: 900, restriction_type: :no_restriction, menu: desserts_menu)
MenuItem.create!(name: "Vegan Sorbet", price_in_cents: 850, restriction_type: :vegan, menu: desserts_menu)

# Drinks
MenuItem.create!(name: "Red Wine", price_in_cents: 1500, restriction_type: :no_restriction, menu: drinks_menu)
MenuItem.create!(name: "Fresh Orange Juice", price_in_cents: 700, restriction_type: :no_restriction, menu: drinks_menu)
