require "test_helper"

class AdminActionsTest < ActionDispatch::IntegrationTest
  setup do
    @customer = create_user
    @branch = create_branch
    @car = create_car
    @order = create_order(user: @customer, branch: @branch, cars: [ @car ])
  end

  test "адміністратор позначає замовлення виконаним, авто стає проданим" do
    sign_in create_user(admin: true)
    patch admin_order_path(@order), params: { status: "completed" }
    assert @order.reload.completed?
    assert @car.reload.sold?
  end

  test "скасування замовлення повертає авто в наявність" do
    sign_in create_user(admin: true)
    patch admin_order_path(@order), params: { status: "cancelled" }
    assert @order.reload.cancelled?
    assert @car.reload.available?
  end

  test "клієнт не може змінювати статус замовлення" do
    sign_in @customer
    patch admin_order_path(@order), params: { status: "completed" }
    assert_redirected_to root_path
    assert @order.reload.deposit_paid?
  end

  test "адміністратор бачить кошик користувача" do
    other_car = create_car
    @customer.current_cart.cart_items.create!(car: other_car)
    sign_in create_user(admin: true)
    get admin_user_path(@customer)
    assert_response :success
    assert_includes response.body, other_car.full_name
  end

  test "адміністратор додає авто" do
    brand = create_brand
    sign_in create_user(admin: true)
    assert_difference "Car.count", 1 do
      post admin_cars_path, params: { car: {
        brand_id: brand.id, name: "Nova", year: 2026, price: 45_000, status: "available",
        body_type: "Кросовер", engine: "2.0", horsepower: 200, transmission: "Автомат",
        drive: "Повний", color: "Білий", description: "Нове авто"
      } }
    end
  end
end
