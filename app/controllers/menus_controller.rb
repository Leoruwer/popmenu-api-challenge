class MenusController < ApplicationController
  def index
    menus = Menu.includes(:menu_items).order(:menu_type, :updated_at)

    render json: menus.as_json(include: { menu_items: { methods: :price } })
  end

  def show
    menu = Menu.find(params[:id])

    render json: menu.as_json(include: { menu_items: { methods: :price } })
  end
end
