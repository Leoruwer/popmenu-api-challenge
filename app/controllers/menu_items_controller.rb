class MenuItemsController < ApplicationController
  before_action :set_menu

  def index
    items = @menu.menu_items

    render json: items.as_json(methods: :price)
  end

  def show
    item = @menu.menu_items.find(params[:id])

    render json: item.as_json(methods: :price)
  end

  private

  def set_menu
    @menu = Menu.find(params[:menu_id])
  end
end
