class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = current_user.current_cart
    @items = @cart.cart_items.includes(car: :brand)
  end
end