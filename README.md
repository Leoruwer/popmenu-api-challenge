# Popmenu Challenge API

## Important Notes

- Consulted Rails and RSpec documentation
- Consulted online resources such as StackOverflow and technical blogs for clarification on specific issues or best practices
- Used AI as a productivity tool for clarifying edge cases, improving explanations, and refining documentation and comments
- All design decisions, implementations, and final code are fully authored and reviewed by me

---

## Challenge

### Level 1: Basics

- Create an object model for `Menu` and `MenuItems` classes.
- `Menu` has many `MenuItems`.
- `Menu` and `MenuItem` have typical data associated with restaurants.
- Create appropriate endpoints to return the model data.
- Illustrate behavior via unit tests.

### Level 2: Multiple Menus

- Introduce a `Restaurant` model, and allow `Restaurant` to have multiple `Menu`.
- `MenuItem` names should not be duplicated in the database.
- `MenuItem` can be on multiple `Menu` of a `Restaurant`.
- Create appropriate endpoints to return the model data.
- Illustrate behavior via unit tests.

### Level 3: Import JSON endpoint

- Create an HTTP endpoint that accepts json files.
- Write a conversion tool to serialize and persist the json file’s data into our menu system. Use the included file, `restaurant_data.json`.
- Make any model/validation changes that you feel are necessary to make the import as complete as possible.
- Make the `json → application model` conversion tool available to run with instructions on how to run it.
- The output of the `json → application model` conversion should return a list of logs for each menu item and a success/fail result.
- Apply what you consider to be adequate logging and exception handling.
- Illustrate behavior via unit tests.

---

## Features

- Import restaurants, menus, and menu items from JSON.
- Prevent creation of duplicate records based on normalized names.
- Proper logging for every creation or linking of records.
- Graceful handling of invalid JSON and record validation errors.
- Rake task to import JSON from environment variables.
- Configurable `menu_type`, defaulting to the menu name if not provided.

---

## JSON Import Format

The JSON should have the following structure:

```json
{
  "restaurants": [
    {
      "name": "Restaurant Name",
      "menus": [
        {
          "name": "Lunch",
          "menu_type": "Main Course",
          "menu_items": [
            { "name": "Burger", "price": 9.0 },
            { "name": "Small Salad", "price": 5.0 }
          ]
        },
        {
          "name": "Dinner",
          "menu_items": [
            { "name": "Burger", "price": 15.0 },
            { "name": "Large Salad", "price": 8.0 }
          ]
        }
      ]
    }
  ]
}
```

**Notes:**

- `menu_type` is optional. If not provided, it defaults to the menu `name`.
- Duplicate restaurant, menu, or menu item names (ignoring spaces and case) are handled gracefully.

---

## Running the JSON Import

### Using the API Endpoint

Send a `POST` request to `/import` with the JSON in the body:

```bash
curl -X POST http://localhost:3000/import \
     -H "Content-Type: application/json" \
     -d restaurants.json
```

Response:

```json
{
  "message": "Data imported successfully",
  "logs": [
    "Created restaurant: Restaurant Name",
    "Created menu: Lunch for restaurant Restaurant Name",
    "Created menu item: Burger (9.0)",
    "Linked Burger to menu Lunch"
  ]
}
```

### Using the Rake Task

Set the `DATA` environment variable and run the task:

With JSON file:

```bash
bin/rails import:json DATA="$(cat restaurants.json)"
```

With JSON string:

```bash
bin/rails import:json DATA="{'json': 'here'}"
```

- Logs will be printed to the console.
- Errors will also be logged with messages.

---

## Testing

The project uses RSpec for both **request specs** and **service specs**.

To run tests:

```bash
bundle exec rspec
```
