class MenusController < ApplicationController
  before_action :set_restaurant

  def show
    menu = Menu.find(params[:id])

    render json: menu.as_json(include: { menu_items: { methods: :price } })
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
