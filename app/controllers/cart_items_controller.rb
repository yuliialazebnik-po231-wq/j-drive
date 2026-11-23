class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_admin
  def create
    car = Car.find(params[:car_id])
    item = current_user.current_cart.cart_items.build(car: car)

    if item.save
      redirect_to cart_path, notice: "#{car.full_name} додано в кошик."
    else
      redirect_to car_path(car), alert: "Не вдалося додати: авто вже в кошику або недоступне."
    end
  end

  def destroy
    item = current_user.current_cart.cart_items.find(params[:id])
    item.destroy
    redirect_to cart_path, notice: "Авто видалено з кошика.", status: :see_other
  end
end
