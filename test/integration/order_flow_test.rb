require "test_helper"

class OrderFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = create_user
    @branch = create_branch
    @car1 = create_car(price: 40_000)
    @car2 = create_car(price: 30_000)
    sign_in @user
  end

  def fill_cart(*cars)
    cars.each { |car| @user.current_cart.cart_items.create!(car: car) }
  end

  def order_params(deposit: 2_500, card_number: "4242424242424242")
    {
      order: { branch_id: @branch.id, deposit_amount: deposit },
      pickup_date: (Date.current + 1).iso8601,
      pickup_time: "10:00",
      card: { number: card_number, holder: "IVAN PETRENKO", expiry: "12/99", cvv: "123" }
    }
  end

  test "повний сценарій: кошик, філія, застава, оплата" do
    fill_cart(@car1, @car2)

    assert_difference "Order.count", 1 do
      post orders_path, params: order_params
    end

    order = Order.last
    assert_redirected_to order_path(order)
    assert_equal 70_000, order.total_price
    assert_equal 2_500, order.deposit_amount
    assert_equal 67_500, order.remaining_amount
    assert_equal "4242", order.card_last4
    assert_equal 2, order.order_items.count
    assert @car1.reload.reserved?
    assert @car2.reload.reserved?
    assert_equal 0, @user.reload.cart.cart_items.count
  end

  test "неправильна картка: замовлення не створюється, авто лишається вільним" do
    fill_cart(@car1)

    assert_no_difference "Order.count" do
      post orders_path, params: order_params(card_number: "1234567812345678")
    end
    assert_response :unprocessable_entity
    assert @car1.reload.available?
  end

  test "авто, яке встигли забронювати, замовити не вдається" do
    fill_cart(@car1)
    @car1.reserved!

    assert_no_difference "Order.count" do
      post orders_path, params: order_params
    end
    assert_redirected_to cart_path
  end

  test "порожній кошик перенаправляє назад у кошик" do
    get new_order_path
    assert_redirected_to cart_path
  end

  test "клієнт не бачить чуже замовлення" do
    other_order = create_order(user: create_user, branch: @branch, cars: [ create_car ])
    get order_path(other_order)
    assert_response :not_found
  end
end
