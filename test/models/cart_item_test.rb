require "test_helper"

class CartItemTest < ActiveSupport::TestCase
  setup do
    @cart = create_user.current_cart
  end

  test "доступне авто можна додати в кошик" do
    assert @cart.cart_items.build(car: create_car).valid?
  end

  test "заброньоване авто додати не можна" do
    assert_not @cart.cart_items.build(car: create_car(status: :reserved)).valid?
  end

  test "те саме авто не можна додати двічі" do
    car = create_car
    @cart.cart_items.create!(car: car)
    assert_not @cart.cart_items.build(car: car).valid?
  end

  test "сума кошика дорівнює сумі цін авто" do
    @cart.cart_items.create!(car: create_car(price: 40_000))
    @cart.cart_items.create!(car: create_car(price: 30_000))
    assert_equal 70_000, @cart.total_price
  end
end
